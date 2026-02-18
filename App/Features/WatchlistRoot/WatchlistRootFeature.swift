//
//  WatchlistRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import WatchlistFeature

@Reducer
struct WatchlistRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var watchlist = WatchlistFeature.State()

        @Presents var movieIntelligence: MovieIntelligenceFeature.State?
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case personDetails(PersonDetailsFeature)
        case movieCastAndCrew(MovieCastAndCrewFeature)
    }

    enum Action {
        case watchlist(WatchlistFeature.Action)
        case movieIntelligence(PresentationAction<MovieIntelligenceFeature.Action>)
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
            case .path(.element(_, .movieDetails(.navigate(.castAndCrew(let id))))):
                state.path.append(.movieCastAndCrew(MovieCastAndCrewFeature.State(movieID: id)))
                return .none
            case .path(.element(_, .movieDetails(.navigate(.movieIntelligence(let id))))):
                state.movieIntelligence = MovieIntelligenceFeature.State(movieID: id)
                return .none
            case .path(
                .element(_, .movieCastAndCrew(.navigate(.personDetails(let id, _))))
            ):
                state.path.append(
                    .personDetails(PersonDetailsFeature.State(personID: id))
                )
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$movieIntelligence, action: \.movieIntelligence) {
            MovieIntelligenceFeature()
        }
    }

}
