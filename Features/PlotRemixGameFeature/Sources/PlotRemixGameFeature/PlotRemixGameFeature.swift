//
//  PlotRemixGameFeature.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PlotRemixGameFeature: Sendable {

    @Dependency(\.plotRemixGameClient) private var plotRemixGameClient

    @ObservableState
    public struct State: Sendable {
        var gameID: Int
        public var viewState: ViewState
        @Presents var playGame: PlotRemixGamePlayFeature.State?

        public var isLoading: Bool {
            switch viewState {
            case .loading: true
            default: false
            }
        }

        public var isReady: Bool {
            switch viewState {
            case .ready: true
            default: false
            }
        }

        public init(
            gameID: Int,
            viewState: ViewState = .initial
        ) {
            self.gameID = gameID
            self.viewState = viewState
        }
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot: Sendable {
        public let metadata: GameMetadata

        public init(metadata: GameMetadata) {
            self.metadata = metadata
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(Error)
        case startGame
        case playGame(PresentationAction<PlotRemixGamePlayFeature.Action>)

    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if state.isReady {
                    state.viewState = .loading
                }

                return handleFetchGameMetadata(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            case .startGame:
                if case .ready(let snapshot) = state.viewState {
                    state.playGame = .init(metadata: snapshot.metadata)
                }

                return .none

            case .playGame:
                return .none
            }
        }
        .ifLet(\.$playGame, action: \.playGame) {
            PlotRemixGamePlayFeature()
        }
    }

}

extension PlotRemixGameFeature {

    private func handleFetchGameMetadata(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            do {
                let metadata = try await plotRemixGameClient.gameMetadata(state.gameID)
                let snapshot = ViewSnapshot(metadata: metadata)
                await send(.loaded(snapshot))
            } catch {
                print("Error: \(error.localizedDescription)")
                await send(.loadFailed(error))
            }
        }
    }
}
