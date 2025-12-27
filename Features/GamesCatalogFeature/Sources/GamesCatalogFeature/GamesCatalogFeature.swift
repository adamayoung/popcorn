//
//  GamesCatalogFeature.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct GamesCatalogFeature: Sendable {

    private static let logger = Logger.gamesCatalog

    @Dependency(\.gamesCatalogClient) private var gamesCatalogClient

    @ObservableState
    public struct State {
        var viewState: ViewState

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

        public init(viewState: ViewState = .initial) {
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
        public let games: [GameMetadata]

        public init(games: [GameMetadata]) {
            self.games = games
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(Error)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case game(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if state.isReady {
                    state.viewState = .loading
                }

                return handleFetchGames(state: &state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            case .navigate:
                return .none
            }
        }
    }

}

extension GamesCatalogFeature {

    private func handleFetchGames(state: inout State) -> EffectOf<Self> {
        .run { [gamesCatalogClient] send in
            Self.logger.info("User fetching games")

            do {
                let games = try await gamesCatalogClient.fetchGames()
                let snapshot = ViewSnapshot(games: games)
                await send(.loaded(snapshot))
            } catch let error {
                Self.logger.error("Failed fetching games: \(error, privacy: .public)")
                await send(.loadFailed(error))
            }
        }
    }

}
