//
//  SearchRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MediaSearchFeature
import MovieDetailsFeature
import PersonDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesDetailsFeature

@Reducer
struct SearchRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var mediaSearch = MediaSearchFeature.State()
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case tvSeriesDetails(TVSeriesDetailsFeature)
        case tvSeasonDetails(TVSeasonDetailsFeature)
        case tvEpisodeDetails(TVEpisodeDetailsPlaceholder)
        case personDetails(PersonDetailsFeature)
    }

    enum Action {
        case mediaSearch(MediaSearchFeature.Action)
        case movieDetails(MovieDetailsFeature.Action)
        case tvSeriesDetails(TVSeriesDetailsFeature.Action)
        case personDetails(PersonDetailsFeature.Action)
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
            case .path(.element(_, .movieDetails(.navigate(.movieDetails(let id))))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none
            case .path(
                .element(
                    _,
                    .tvSeriesDetails(
                        .navigate(.seasonDetails(let tvSeriesID, let seasonNumber, let seasonName))
                    )
                )
            ):
                state.path.append(
                    .tvSeasonDetails(
                        TVSeasonDetailsFeature.State(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber,
                            seasonName: seasonName
                        )
                    )
                )
                return .none
            case .path(
                .element(
                    _,
                    .tvSeasonDetails(
                        .navigate(
                            .episodeDetails(let tvSeriesID, let seasonNumber, let episodeNumber)
                        )
                    )
                )
            ):
                state.path.append(
                    .tvEpisodeDetails(
                        TVEpisodeDetailsPlaceholder.State(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber,
                            episodeNumber: episodeNumber
                        )
                    )
                )
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
