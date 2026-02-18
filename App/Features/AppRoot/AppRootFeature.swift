//
//  AppRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import DesignSystem
#if DEBUG
    import DeveloperFeature
#endif
import Foundation

@Reducer
struct AppRootFeature {

    @Dependency(\.appRootClient) private var appRootClient

    @ObservableState
    struct State {
        var selectedTab: Tab = .explore
        var explore = ExploreRootFeature.State()
        var watchlist = WatchlistRootFeature.State()
        var games = GamesRootFeature.State()
        var search = SearchRootFeature.State()
        #if DEBUG
            @Presents var developer: DeveloperFeature.State?
        #endif

        var isExploreEnabled: Bool = false
        var isWatchlistEnabled: Bool = false
        var isGamesEnabled: Bool = false
        var isSearchEnabled: Bool = false

        var hasStarted: Bool = false
        var isReady: Bool = false
        var error: Error?
    }

    enum Tab {
        case explore
        case watchlist
        case games
        case search

        var id: String {
            switch self {
            case .explore: "popcorn.tab.explore"
            case .watchlist: "popcorn.tab.watchlist"
            case .games: "popcorn.tab.games"
            case .search: "popcorn.tab.search"
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didAppear
        case setupComplete
        case setupFailed(Error)
        case updateFeatureFlags
        case explore(ExploreRootFeature.Action)
        case watchlist(WatchlistRootFeature.Action)
        case games(GamesRootFeature.Action)
        case search(SearchRootFeature.Action)
        #if DEBUG
            case developer(PresentationAction<DeveloperFeature.Action>)
            case navigate(Navigation)
        #endif
    }

    #if DEBUG
        enum Navigation: Equatable, Hashable {
            case developer
        }
    #endif

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .didAppear:
                guard !state.hasStarted else {
                    return .none
                }

                state.hasStarted = true

                return handleSetup()

            case .setupComplete:
                return .run { send in
                    await send(.updateFeatureFlags)
                }

            case .setupFailed(let error):
                state.error = error
                return .none

            case .updateFeatureFlags:
                state.isExploreEnabled = (try? appRootClient.isExploreEnabled()) ?? false
                state.isWatchlistEnabled = (try? appRootClient.isWatchlistEnabled()) ?? false
                state.isGamesEnabled = (try? appRootClient.isGamesEnabled()) ?? false
                state.isSearchEnabled = (try? appRootClient.isSearchEnabled()) ?? false
                state.isReady = true
                return .none

            #if DEBUG
                case .navigate(.developer):
                    if state.developer == nil {
                        state.developer = DeveloperFeature.State()
                    }
                    return .none
            #endif

            default:
                return .none
            }
        }
        #if DEBUG
        .ifLet(\.$developer, action: \.developer) { DeveloperFeature() }
        #endif

        Scope(state: \.explore, action: \.explore) { ExploreRootFeature() }
        Scope(state: \.watchlist, action: \.watchlist) { WatchlistRootFeature() }
        Scope(state: \.games, action: \.games) { GamesRootFeature() }
        Scope(state: \.search, action: \.search) { SearchRootFeature() }
    }

}

extension AppRootFeature {

    private func handleSetup() -> EffectOf<Self> {
        .run { [appRootClient] send in
            FocalPointAnalyzer.warmUp()

            do {
                async let observability: Void = appRootClient.setupObservability()
                async let featureFlags: Void = appRootClient.setupFeatureFlags()

                _ = try await (observability, featureFlags)
                await send(.setupComplete)
            } catch let error {
                await send(.setupFailed(error))
            }
        }
    }

}

extension AppRootFeature.Tab: @nonisolated Equatable, @nonisolated Hashable {}
