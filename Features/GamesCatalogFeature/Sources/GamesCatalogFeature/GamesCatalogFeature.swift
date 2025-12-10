//
//  GamesCatalogFeature.swift
//  GamesCatalogFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct GamesCatalogFeature: Sendable {

    @Dependency(\.gamesCatalog) private var gamesCatalog: GamesCatalogClient

    @ObservableState
    public struct State {
        var games: [GameMetadata]?

        public init(
            games: [GameMetadata]? = nil
        ) {
            self.games = games
        }
    }

    public enum Action {
        case loadGames
        case gamesLoaded([GameMetadata])
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case game(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGames:
                return handleLoadGames(state: &state)

            case .gamesLoaded(let games):
                state.games = games
                return .none

            case .navigate:
                return .none
            }
        }
    }

}

extension GamesCatalogFeature {

    private func handleLoadGames(state: inout State) -> EffectOf<Self> {
        .run { send in
            let games = try await gamesCatalog.fetchGames()
            await send(.gamesLoaded(games))
        }
    }

}
