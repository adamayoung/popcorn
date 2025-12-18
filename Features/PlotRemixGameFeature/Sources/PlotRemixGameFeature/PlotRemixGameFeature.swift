//
//  PlotRemixGameFeature.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 09/12/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import Observability

@Reducer
public struct PlotRemixGameFeature: Sendable {

    @Dependency(\.plotRemixGameClient) private var plotRemixGameClient
    @Dependency(\.observability) private var observability
    @Dependency(\.dismiss) private var dismiss

    private static let logger = Logger(
        subsystem: "PlotRemixGameFeature",
        category: "PlotRemixGameFeatureReducer"
    )

    @ObservableState
    public struct State: Sendable {
        var gameID: Int
        var isLoading: Bool
        var metadata: GameMetadata?
        var isGeneratingGame: Bool
        var generatingProgress: Float?
        var game: Game?
        var error: Error?

        public init(
            gameID: Int,
            isLoading: Bool = false,
            metadata: GameMetadata? = nil,
            isGeneratingGame: Bool = false,
            generatingProgress: Float? = nil,
            game: Game? = nil,
            error: Error? = nil
        ) {
            self.gameID = gameID
            self.isLoading = isLoading
            self.metadata = metadata
            self.isGeneratingGame = isGeneratingGame
            self.generatingProgress = generatingProgress
            self.game = game
            self.error = error
        }
    }

    public enum Action {
        case fetchMetadata
        case metadataLoaded(GameMetadata)
        case metadataLoadFailed(Error)
        case generateGame
        case generatingGame(Float)
        case generatedGame(Game)
        case generateGameFailed(Error)
        case startGame
        case answerQuestion(Int, Int)
        case endGame
        case close

    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMetadata:
                guard state.metadata == nil else {
                    return .none
                }

                return handleFetchGameMetadata(&state)

            case .metadataLoaded(let metadata):
                state.metadata = metadata
                return .none

            case .metadataLoadFailed(let error):
                state.error = error
                return .none

            case .generateGame:
                state.isGeneratingGame = true
                return handleGenerateGame(&state)

            case .generatingGame(let progress):
                state.generatingProgress = progress
                return .none

            case .generatedGame(let game):
                state.game = game
                return .run { send in
                    await send(.startGame)
                }

            case .generateGameFailed(let error):
                state.generatingProgress = nil
                state.isGeneratingGame = false
                state.error = error
                return .none

            case .startGame:
                guard state.game != nil else {
                    return .none
                }
                return .none

            case .answerQuestion:
                return .none

            case .endGame:
                return .none

            case .close:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }

}

extension PlotRemixGameFeature {

    private func handleFetchGameMetadata(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            let transaction = observability.startTransaction(
                name: "FetchGameMetadata",
                operation: .uiAction
            )
            transaction.setData(key: "game_id", value: state.gameID)

            do {
                let metadata = try await plotRemixGameClient.gameMetadata(state.gameID)
                transaction.finish()
                await send(.metadataLoaded(metadata))
            } catch let error {
                Self.logger.error("Failed fetching game metadata: \(error.localizedDescription)")
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.metadataLoadFailed(error))
            }
        }
    }

    private func handleGenerateGame(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            guard state.metadata != nil else {
                return
            }

            let transaction = observability.startTransaction(
                name: "GenerateGame",
                operation: .uiAction
            )
            transaction.setData(key: "game_id", value: state.gameID)

            let game: Game
            do {
                game = try await plotRemixGameClient.generateGame { progress in
                    guard !Task.isCancelled else { return }
                    Task {
                        guard !Task.isCancelled else { return }
                        await send(.generatingGame(progress))
                    }
                }
                transaction.finish()
            } catch is CancellationError {
                transaction.finish()
                return
            } catch let error {
                guard !Task.isCancelled else {
                    transaction.finish()
                    return
                }
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.generateGameFailed(error))
                return
            }

            guard !Task.isCancelled else {
                transaction.finish()
                return
            }

            transaction.finish()
            await send(.generatedGame(game))
        }
    }
}
