//
//  ExploreRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import ExploreFeature
import Foundation
import MovieDetailsFeature
import PersonDetailsFeature
import TVSeriesDetailsFeature

@Reducer
struct ExploreRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var explore = ExploreFeature.State()
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case tvSeriesDetails(TVSeriesDetailsFeature)
        case personDetails(PersonDetailsFeature)
    }

    enum Action {
        case explore(ExploreFeature.Action)
        case movieDetails(MovieDetailsFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.explore, action: \.explore) { ExploreFeature() }

        Reduce { state, action in
            switch action {
            case .explore(.navigate(.movieDetails(let id, let transitionID))):
                state.path.append(
                    .movieDetails(
                        MovieDetailsFeature.State(movieID: id, transitionID: transitionID)
                    )
                )
                return .none
            case .explore(.navigate(.tvSeriesDetails(let id, let transitionID))):
                state.path.append(
                    .tvSeriesDetails(
                        TVSeriesDetailsFeature.State(tvSeriesID: id, transitionID: transitionID)
                    )
                )
                return .none
            case .explore(.navigate(.personDetails(let id, let transitionID))):
                state.path.append(
                    .personDetails(
                        PersonDetailsFeature.State(personID: id, transitionID: transitionID)
                    )
                )
                return .none
            case .path(.element(_, .movieDetails(.navigate(.movieDetails(let id))))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
