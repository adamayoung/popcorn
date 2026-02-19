//
//  ExploreRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import ExploreFeature
import Foundation
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature

@Reducer
struct ExploreRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var explore = ExploreFeature.State()

        @Presents var movieIntelligence: MovieIntelligenceFeature.State?
        @Presents var tvSeriesIntelligence: TVSeriesIntelligenceFeature.State?
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case tvSeriesDetails(TVSeriesDetailsFeature)
        case tvSeasonDetails(TVSeasonDetailsPlaceholder)
        case personDetails(PersonDetailsFeature)
        case movieCastAndCrew(MovieCastAndCrewFeature)
    }

    enum Action {
        case explore(ExploreFeature.Action)
        case movieDetails(MovieDetailsFeature.Action)
        case movieIntelligence(PresentationAction<MovieIntelligenceFeature.Action>)
        case tvSeriesIntelligence(PresentationAction<TVSeriesIntelligenceFeature.Action>)
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
            case .path(.element(_, .movieDetails(.navigate(.movieIntelligence(let id))))):
                state.movieIntelligence = MovieIntelligenceFeature.State(movieID: id)
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
            case .path(
                .element(_, .movieCastAndCrew(.navigate(.personDetails(let id, _))))
            ):
                state.path.append(
                    .personDetails(PersonDetailsFeature.State(personID: id))
                )
                return .none
            case .path(.element(_, .tvSeriesDetails(.navigate(.tvSeriesIntelligence(let id))))):
                state.tvSeriesIntelligence = TVSeriesIntelligenceFeature.State(tvSeriesID: id)
                return .none
            case .path(.element(_, .tvSeriesDetails(.navigate(.seasonDetails(let tvSeriesID, let seasonNumber))))):
                state.path.append(
                    .tvSeasonDetails(
                        TVSeasonDetailsPlaceholder.State(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
                    )
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
        .ifLet(\.$tvSeriesIntelligence, action: \.tvSeriesIntelligence) {
            TVSeriesIntelligenceFeature()
        }
    }

}
