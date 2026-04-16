//
//  SearchRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MediaSearchFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature

@Reducer
struct SearchRootFeature {

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var mediaSearch = MediaSearchFeature.State()

        @Presents var movieIntelligence: MovieIntelligenceFeature.State?
        @Presents var tvSeriesIntelligence: TVSeriesIntelligenceFeature.State?
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case tvSeriesDetails(TVSeriesDetailsFeature)
        case tvSeasonDetails(TVSeasonDetailsFeature)
        case tvEpisodeDetails(TVEpisodeDetailsFeature)
        case personDetails(PersonDetailsFeature)
        case movieCastAndCrew(MovieCastAndCrewFeature)
        case tvSeriesCastAndCrew(TVSeriesCastAndCrewFeature)
        case tvEpisodeCastAndCrew(TVEpisodeCastAndCrewFeature)
    }

    enum Action {
        case mediaSearch(MediaSearchFeature.Action)
        case movieDetails(MovieDetailsFeature.Action)
        case tvSeriesDetails(TVSeriesDetailsFeature.Action)
        case personDetails(PersonDetailsFeature.Action)
        case movieIntelligence(PresentationAction<MovieIntelligenceFeature.Action>)
        case tvSeriesIntelligence(PresentationAction<TVSeriesIntelligenceFeature.Action>)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.mediaSearch, action: \.mediaSearch) { MediaSearchFeature() }

        Reduce { state, action in
            switch action {
            case .mediaSearch(.navigate(.movieDetails(let id))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none
            case .mediaSearch(.navigate(.tvSeriesDetails(let id))):
                state.path.append(.tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: id)))
                return .none
            case .mediaSearch(.navigate(.personDetails(let id))):
                state.path.append(.personDetails(PersonDetailsFeature.State(personID: id)))
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
            case .path(
                .element(
                    _,
                    .tvSeriesDetails(
                        .navigate(.seasonDetails(let tvSeriesID, let seasonNumber))
                    )
                )
            ):
                state.path.append(
                    .tvSeasonDetails(
                        TVSeasonDetailsFeature.State(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber
                        )
                    )
                )
                return .none
            case .path(.element(_, .tvSeriesDetails(.navigate(.personDetails(let id))))):
                state.path.append(.personDetails(PersonDetailsFeature.State(personID: id)))
                return .none
            case .path(.element(_, .tvSeriesDetails(.navigate(.castAndCrew(let id))))):
                state.path.append(
                    .tvSeriesCastAndCrew(TVSeriesCastAndCrewFeature.State(tvSeriesID: id))
                )
                return .none
            case .path(
                .element(_, .tvSeriesCastAndCrew(.navigate(.personDetails(let id, _))))
            ):
                state.path.append(
                    .personDetails(PersonDetailsFeature.State(personID: id))
                )
                return .none
            case .path(
                .element(
                    _,
                    .tvSeasonDetails(
                        .navigate(
                            .episodeDetails(
                                let tvSeriesID, let seasonNumber,
                                let episodeNumber
                            )
                        )
                    )
                )
            ):
                state.path.append(
                    .tvEpisodeDetails(
                        TVEpisodeDetailsFeature.State(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber,
                            episodeNumber: episodeNumber
                        )
                    )
                )
                return .none
            case .path(
                .element(
                    _,
                    .tvEpisodeDetails(
                        .navigate(
                            .castAndCrew(let tvSeriesID, let seasonNumber, let episodeNumber)
                        )
                    )
                )
            ):
                state.path.append(
                    .tvEpisodeCastAndCrew(
                        TVEpisodeCastAndCrewFeature.State(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber,
                            episodeNumber: episodeNumber
                        )
                    )
                )
                return .none
            case .path(.element(_, .tvEpisodeDetails(.navigate(.personDetails(let id))))):
                state.path.append(.personDetails(PersonDetailsFeature.State(personID: id)))
                return .none
            case .path(
                .element(_, .tvEpisodeCastAndCrew(.navigate(.personDetails(let id, _))))
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
        .ifLet(\.$tvSeriesIntelligence, action: \.tvSeriesIntelligence) {
            TVSeriesIntelligenceFeature()
        }
    }

}

extension SearchRootFeature.Path.State: Equatable {}
