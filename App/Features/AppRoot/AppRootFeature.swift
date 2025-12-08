//
//  AppRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import FeatureFlags
import FeatureFlagsAdapters
import Foundation

@Reducer
struct AppRootFeature {

    @Dependency(\.featureFlags) var featureFlags

    @ObservableState
    struct State {
        var selectedTab: Tab = .explore
        var explore = ExploreRootFeature.State()
        var movies = MoviesRootFeature.State()
        var tv = TVRootFeature.State()
        var people = PeopleRootFeature.State()
        var search = SearchRootFeature.State()
        var isSearchEnabled: Bool = false

        var isReady: Bool = false
    }

    enum Tab {
        case explore
        case movies
        case tv
        case people
        case search

        var id: String {
            switch self {
            case .explore: "popcorn.tab.explore"
            case .movies: "popcorn.tab.movies"
            case .tv: "popcorn.tab.tv"
            case .people: "popcorn.tab.people"
            case .search: "popcorn.tab.search"
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didAppear
        case featureFlagsLoaded(searchEnabled: Bool)
        case explore(ExploreRootFeature.Action)
        case movies(MoviesRootFeature.Action)
        case tv(TVRootFeature.Action)
        case people(PeopleRootFeature.Action)
        case search(SearchRootFeature.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { [featureFlags] send in
                    let searchEnabled = featureFlags.isEnabled("media_search")
                    await send(.featureFlagsLoaded(searchEnabled: searchEnabled))
                }

            case .featureFlagsLoaded(let searchEnabled):
                state.isSearchEnabled = searchEnabled
                state.isReady = true
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.explore, action: \.explore) { ExploreRootFeature() }
        Scope(state: \.movies, action: \.movies) { MoviesRootFeature() }
        Scope(state: \.tv, action: \.tv) { TVRootFeature() }
        Scope(state: \.people, action: \.people) { PeopleRootFeature() }
        Scope(state: \.search, action: \.search) { SearchRootFeature() }
    }

}

extension AppRootFeature.Tab: @nonisolated Equatable, @nonisolated Hashable {}
