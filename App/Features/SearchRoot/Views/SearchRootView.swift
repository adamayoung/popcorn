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
import PersonDetailsFeature
import SwiftUI
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature

/// The MVVM Search tab root. Hosts the media search home in a `NavigationStack`,
/// drives push navigation (movie / TV series / season / episode details, person
/// details, cast and crew) and the movie / TV series intelligence modals via
/// ``SearchRouter``. The MVVM replacement for the store-based `SearchRootView` +
/// `SearchRootFeature`.
struct SearchRootView: View {

    @Bindable private var router: SearchRouter
    private let factory: ViewModelFactory
    private let namespace: Namespace.ID

    /// The home view model, owned here (above the screen seam) so it survives the
    /// router-driven body re-renders that push/present cause. ``MediaSearchScreen``
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
            MediaSearchScreen(viewModel: mediaSearchViewModel)
                .navigationDestination(for: SearchRoute.self) { route in
                    destination(route)
                }
        }
        #if !os(macOS)
        .fullScreenCover(item: $router.presentedMovieIntelligence) { intel in
            MovieIntelligenceScreen(
                viewModel: factory.makeMovieIntelligence(movieID: intel.movieID)
            )
        }
        .fullScreenCover(item: $router.presentedTVSeriesIntelligence) { intel in
            TVSeriesIntelligenceScreen(
                viewModel: factory.makeTVSeriesIntelligence(tvSeriesID: intel.tvSeriesID)
            )
        }
        #else
        .sheet(item: $router.presentedMovieIntelligence) { intel in
                    MovieIntelligenceScreen(
                        viewModel: factory.makeMovieIntelligence(movieID: intel.movieID)
                    )
                }
                .sheet(item: $router.presentedTVSeriesIntelligence) { intel in
                    TVSeriesIntelligenceScreen(
                        viewModel: factory.makeTVSeriesIntelligence(tvSeriesID: intel.tvSeriesID)
                    )
                }
        #endif
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
            PersonDetailsScreen(
                viewModel: factory.makePersonDetails(id: id, navigator: navigator)
            )
        case .movieCastAndCrew(let movieID):
            MovieCastAndCrewScreen(
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
            MovieDetailsScreen(viewModel: viewModel)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsScreen(viewModel: viewModel)
        }
    }

    private func tvSeriesDetails(id: Int) -> some View {
        TVSeriesDetailsScreen(
            viewModel: factory.makeTVSeriesDetails(id: id, navigator: navigator)
        )
    }

    private func tvSeasonDetails(tvSeriesID: Int, seasonNumber: Int) -> some View {
        TVSeasonDetailsScreen(
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
        TVEpisodeDetailsScreen(
            viewModel: factory.makeTVEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                navigator: navigator
            )
        )
    }

    private func tvSeriesCastAndCrew(tvSeriesID: Int) -> some View {
        TVSeriesCastAndCrewScreen(
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
        TVEpisodeCastAndCrewScreen(
            viewModel: factory.makeTVEpisodeCastAndCrew(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                navigator: navigator
            )
        )
    }

}
