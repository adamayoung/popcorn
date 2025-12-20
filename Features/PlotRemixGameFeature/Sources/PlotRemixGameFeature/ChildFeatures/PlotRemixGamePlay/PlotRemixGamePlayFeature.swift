//
//  PlotRemixGamePlayFeature.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PlotRemixGamePlayFeature: Sendable {

    @Dependency(\.plotRemixGamePlayClient) private var plotRemixGamePlayClient
    @Dependency(\.dismiss) private var dismiss

    @ObservableState
    public struct State: Sendable {
        public var metadata: GameMetadata
        public var viewState: ViewState

        public var isLoading: Bool {
            switch viewState {
            case .generating: true
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
            metadata: GameMetadata,
            viewState: ViewState = .initial
        ) {
            self.metadata = metadata
            self.viewState = viewState
        }
    }

    public enum ViewState: Sendable {
        case initial
        case generating(Float = 0.0)
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot: Sendable {
        public let game: Game

        public init(game: Game) {
            self.game = game
        }
    }

    public enum Action {
        case generate
        case generating(Float)
        case generated(ViewSnapshot)
        case generateFailed(Error)
        case close
    }

    private enum CancelID {
        case generateGame
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .generate:
                if case .initial = state.viewState {
                    state.viewState = .generating()
                }

                return handleGenerateGame(&state)
                    .cancellable(id: CancelID.generateGame, cancelInFlight: true)

            case .generating(let progress):
                state.viewState = .generating(progress)
                return .none

            case .generated(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .generateFailed(let error):
                state.viewState = .error(error)
                return .none

            case .close:
                return .concatenate(
                    .cancel(id: CancelID.generateGame),
                    .run { _ in
                        await dismiss()
                    }
                )
            }
        }
    }

}

extension PlotRemixGamePlayFeature {

    private func handleGenerateGame(_ state: inout State) -> EffectOf<Self> {
        .run { send in
            let game: Game
            do {
                game = try await plotRemixGamePlayClient.generateGame { progress in
                    guard !Task.isCancelled else {
                        return
                    }

                    Task {
                        guard !Task.isCancelled else {
                            return
                        }
                        await send(.generating(progress))
                    }
                }
            } catch is CancellationError {
                return
            } catch let error {
                guard !Task.isCancelled else {
                    return
                }
                await send(.generateFailed(error))
                return
            }

            let snapshot = ViewSnapshot(game: game)
            guard !Task.isCancelled else {
                return
            }
            await send(.generated(snapshot))
        }
    }

}
