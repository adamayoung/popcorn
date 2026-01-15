//
//  GamesCatalogFeature.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog
import TCAFoundation

@Reducer
public struct GamesCatalogFeature: Sendable {

    private static let logger = Logger.gamesCatalog

    @Dependency(\.gamesCatalogClient) private var client
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State {
        var viewState: ViewState<ViewSnapshot>

        public init(viewState: ViewState<ViewSnapshot> = .initial) {
            self.viewState = viewState
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let games: [GameMetadata]

        public init(games: [GameMetadata]) {
            self.games = games
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
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
                if state.viewState.isReady {
                    state.viewState = .loading
                }

                return handleFetchGames()

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

    private func handleFetchGames() -> EffectOf<Self> {
        .run { [client] send in
            Self.logger.info("User fetching games")

            let snapshot: ViewSnapshot
            do {
                let games = try await client.fetchGames()
                snapshot = ViewSnapshot(games: games)
            } catch {
                Self.logger.error("Failed fetching games: \(error, privacy: .public)")
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            await send(.loaded(snapshot))
        }
    }

}
