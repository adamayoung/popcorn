//
//  WatchlistRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MovieDetailsFeature
import PersonDetailsFeature
import WatchlistFeature

@Reducer
struct WatchlistRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var watchlist = WatchlistFeature.State()
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case personDetails(PersonDetailsFeature)
    }

    enum Action {
        case watchlist(WatchlistFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.watchlist, action: \.watchlist) { WatchlistFeature() }

        Reduce { state, action in
            switch action {
            case .watchlist(.navigate(.movieDetails(let id, let transitionID))):
                state.path.append(
                    .movieDetails(
                        MovieDetailsFeature.State(movieID: id, transitionID: transitionID)
                    )
                )
                return .none
            case .path(.element(_, .movieDetails(.navigate(.movieDetails(let id))))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none
            case .path(.element(_, .movieDetails(.navigate(.personDetails(let id))))):
                state.path.append(.personDetails(PersonDetailsFeature.State(personID: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
