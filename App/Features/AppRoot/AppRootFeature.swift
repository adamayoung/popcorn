//
//  AppRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 17/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation

@Reducer
struct AppRootFeature {

    @Dependency(\.appRootClient) private var appRootClient

    @ObservableState
    struct State {
        var selectedTab: Tab = .explore
        var explore = ExploreRootFeature.State()
        var games = GamesRootFeature.State()
        var search = SearchRootFeature.State()

        var isExploreEnabled: Bool = false
        var isGamesEnabled: Bool = false
        var isSearchEnabled: Bool = false

        var hasStarted: Bool = false
        var isReady: Bool = false
    }

    enum Tab {
        case explore
        case games
        case search

        var id: String {
            switch self {
            case .explore: "popcorn.tab.explore"
            case .games: "popcorn.tab.games"
            case .search: "popcorn.tab.search"
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didAppear
        case featureFlagsInitialised
        case updateFeatureFlags
        case explore(ExploreRootFeature.Action)
        case games(GamesRootFeature.Action)
        case search(SearchRootFeature.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .didAppear:
                guard !state.hasStarted else {
                    return .none
                }

                state.hasStarted = true

                return handleInitialiseFeatureFlags()

            case .featureFlagsInitialised:
                return .run { send in
                    await send(.updateFeatureFlags)
                }

            case .updateFeatureFlags:
                state.isExploreEnabled = (try? appRootClient.isExploreEnabled()) ?? false
                state.isGamesEnabled = (try? appRootClient.isGamesEnabled()) ?? false
                state.isSearchEnabled = (try? appRootClient.isSearchEnabled()) ?? false
                state.isReady = true
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.explore, action: \.explore) { ExploreRootFeature() }
        Scope(state: \.games, action: \.games) { GamesRootFeature() }
        Scope(state: \.search, action: \.search) { SearchRootFeature() }
    }

}

extension AppRootFeature {

    private func handleInitialiseFeatureFlags() -> EffectOf<Self> {
        .run { [appRootClient] send in
            try await appRootClient.startFeatureFlags()
            await send(.featureFlagsInitialised)
        }
    }

}

extension AppRootFeature.Tab: @nonisolated Equatable, @nonisolated Hashable {}
