//
//  MoviesRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import MovieDetailsFeature
import TrendingMoviesFeature

@Reducer
struct MoviesRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var trending = TrendingMoviesFeature.State()
    }

    @Reducer
    enum Path {
        case details(MovieDetailsFeature)
    }

    enum Action {
        case trending(TrendingMoviesFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.trending, action: \.trending) {
            TrendingMoviesFeature()
        }

        Reduce { state, action in
            switch action {
            case .trending(.navigate(.movieDetails(let id))):
                state.path.append(.details(MovieDetailsFeature.State(movieID: id)))
                return .none
            case .path(.element(_, .details(.navigate(.movieDetails(let id))))):
                state.path.append(.details(MovieDetailsFeature.State(movieID: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
