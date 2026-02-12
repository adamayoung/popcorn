//
//  PlotRemixGameFeature.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct PlotRemixGameFeature: Sendable {

    private static let logger = Logger.plotRemixGame

    @Dependency(\.plotRemixGameClient) private var client
    @Dependency(\.dismiss) private var dismiss

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
        .run { [state, client] send in
            Self.logger.info(
                "User fetching game metadata [gameID: \(state.gameID, privacy: .private)]"
            )

            let metadata: GameMetadata
            do {
                metadata = try await client.gameMetadata(state.gameID)
            } catch let error {
                Self.logger.error(
                    "Failed fetching game metadata [gameID: \(state.gameID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.metadataLoadFailed(error))
                return
            }

            await send(.metadataLoaded(metadata))
        }
    }

    private func handleGenerateGame(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            guard state.metadata != nil else {
                return
            }

            Self.logger.info("User generating game [gameID: \(state.gameID, privacy: .private)]")

            let game: Game
            do {
                game = try await client.generateGame { progress in
                    guard !Task.isCancelled else {
                        return
                    }
                    Task {
                        guard !Task.isCancelled else {
                            return
                        }
                        await send(.generatingGame(progress))
                    }
                }
            } catch is CancellationError {
                return
            } catch let error {
                guard !Task.isCancelled else {
                    return
                }

                Self.logger.error(
                    "Failed generating game [gameID: \(state.gameID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.generateGameFailed(error))
                return
            }

            guard !Task.isCancelled else {
                return
            }

            await send(.generatedGame(game))
        }
    }
}
