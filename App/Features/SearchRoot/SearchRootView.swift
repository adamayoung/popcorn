//
//  SearchRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import MediaSearchFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonCreditsFeature
import PersonDetailsFeature
import SwiftUI
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature

/// The Search tab root. Hosts the media search home in a `NavigationStack`,
/// drives push navigation (movie / TV series / season / episode details, person
/// details, cast and crew) and the movie / TV series intelligence modals via
/// ``SearchRouter``.
struct SearchRootView: View {

    @Bindable private var router: SearchRouter
    private let factory: ViewModelFactory
    private let namespace: Namespace.ID

    /// The home view model, owned here (above the screen seam) so it survives the
    /// router-driven body re-renders that push/present cause. ``MediaSearchView``
    /// therefore stores it as a plain `let`.
    @State private var mediaSearchViewModel: MediaSearchViewModel

    init(
        router: SearchRouter,
        factory: ViewModelFactory,
        namespace: Namespace.ID
    ) {
        _router = Bindable(wrappedValue: router)
        self.factory = factory
        self.namespace = namespace
        _mediaSearchViewModel = State(
            initialValue: factory.makeMediaSearch(
                navigator: SearchRouterNavigator(router: router)
            )
        )
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            MediaSearchView(viewModel: mediaSearchViewModel)
                .navigationDestination(for: SearchRoute.self) { route in
                    destination(route)
                }
        }
        .platformModal(item: $router.presentedMovieIntelligence) { intel in
            MovieIntelligenceView(
                viewModel: factory.makeMovieIntelligence(movieID: intel.movieID)
            )
        }
        .platformModal(item: $router.presentedTVSeriesIntelligence) { intel in
            TVSeriesIntelligenceView(
                viewModel: factory.makeTVSeriesIntelligence(tvSeriesID: intel.tvSeriesID)
            )
        }
    }

    /// A fresh navigator bound to this view's router. Each destination builds its
    /// own (the navigator is a cheap value type wrapping the shared router).
    private var navigator: SearchRouterNavigator {
        SearchRouterNavigator(router: router)
    }

    @ViewBuilder
    private func destination(_ route: SearchRoute) -> some View {
        switch route {
        case .movieDetails(let id, let transitionID):
            movieDetails(id: id, transitionID: transitionID)
        case .tvSeriesDetails(let id):
            tvSeriesDetails(id: id)
        case .tvSeasonDetails(let tvSeriesID, let seasonNumber):
            tvSeasonDetails(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
        case .tvEpisodeDetails(let tvSeriesID, let seasonNumber, let episodeNumber):
            tvEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        case .personDetails(let id):
            PersonDetailsView(
                viewModel: factory.makePersonDetails(id: id, navigator: navigator)
            )
        case .personCredits(let personID):
            PersonCreditsView(
                viewModel: factory.makePersonCredits(personID: personID, navigator: navigator)
            )
        case .movieCastAndCrew(let movieID):
            MovieCastAndCrewView(
                viewModel: factory.makeMovieCastAndCrew(movieID: movieID, navigator: navigator)
            )
        case .tvSeriesCastAndCrew(let tvSeriesID):
            tvSeriesCastAndCrew(tvSeriesID: tvSeriesID)
        case .tvEpisodeCastAndCrew(let tvSeriesID, let seasonNumber, let episodeNumber):
            tvEpisodeCastAndCrew(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        }
    }

    @ViewBuilder
    private func movieDetails(id: Int, transitionID: String?) -> some View {
        let viewModel = factory.makeMovieDetails(
            id: id,
            transitionID: transitionID,
            navigator: navigator
        )
        if let transitionID {
            MovieDetailsView(viewModel: viewModel)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsView(viewModel: viewModel)
        }
    }

    private func tvSeriesDetails(id: Int) -> some View {
        TVSeriesDetailsView(
            viewModel: factory.makeTVSeriesDetails(id: id, navigator: navigator)
        )
    }

    private func tvSeasonDetails(tvSeriesID: Int, seasonNumber: Int) -> some View {
        TVSeasonDetailsView(
            viewModel: factory.makeTVSeasonDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                navigator: navigator
            )
        )
    }

    private func tvEpisodeDetails(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> some View {
        TVEpisodeDetailsView(
            viewModel: factory.makeTVEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                navigator: navigator
            )
        )
    }

    private func tvSeriesCastAndCrew(tvSeriesID: Int) -> some View {
        TVSeriesCastAndCrewView(
            viewModel: factory.makeTVSeriesCastAndCrew(
                tvSeriesID: tvSeriesID,
                navigator: navigator
            )
        )
    }

    private func tvEpisodeCastAndCrew(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> some View {
        TVEpisodeCastAndCrewView(
            viewModel: factory.makeTVEpisodeCastAndCrew(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                navigator: navigator
            )
        )
    }

}
