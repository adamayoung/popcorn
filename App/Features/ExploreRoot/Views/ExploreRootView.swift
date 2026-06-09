//
//  ExploreRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ExploreFeature
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

/// The MVVM Explore tab root. Hosts the explore home in a `NavigationStack`,
/// drives push navigation (movie / TV series / season / episode details, person
/// details, cast and crew) and the movie / TV series intelligence modals via
/// ``ExploreRouter``. The MVVM replacement for the store-based `ExploreRootView` +
/// `ExploreRootFeature`.
struct ExploreRootView: View {

    @Bindable private var router: ExploreRouter
    private let factory: ViewModelFactory
    private let namespace: Namespace.ID

    /// The home view model, owned here (above the screen seam) so it survives the
    /// router-driven body re-renders that push/present cause. ``ExploreScreen``
    /// therefore stores it as a plain `let`.
    @State private var exploreViewModel: ExploreViewModel

    init(
        router: ExploreRouter,
        factory: ViewModelFactory,
        namespace: Namespace.ID
    ) {
        _router = Bindable(wrappedValue: router)
        self.factory = factory
        self.namespace = namespace
        _exploreViewModel = State(
            initialValue: factory.makeExplore(
                navigator: ExploreRouterNavigator(router: router)
            )
        )
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ExploreScreen(viewModel: exploreViewModel, transitionNamespace: namespace)
                .navigationDestination(for: ExploreRoute.self) { route in
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
    private var navigator: ExploreRouterNavigator {
        ExploreRouterNavigator(router: router)
    }

    @ViewBuilder
    private func destination(_ route: ExploreRoute) -> some View {
        switch route {
        case .movieDetails(let id, let transitionID):
            movieDetails(id: id, transitionID: transitionID)
        case .tvSeriesDetails(let id, let transitionID):
            tvSeriesDetails(id: id, transitionID: transitionID)
        case .tvSeasonDetails(let tvSeriesID, let seasonNumber):
            tvSeasonDetails(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
        case .tvEpisodeDetails(let tvSeriesID, let seasonNumber, let episodeNumber):
            tvEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        case .personDetails(let id, let transitionID):
            personDetails(id: id, transitionID: transitionID)
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

    @ViewBuilder
    private func tvSeriesDetails(id: Int, transitionID: String?) -> some View {
        let viewModel = factory.makeTVSeriesDetails(id: id, navigator: navigator)
        if let transitionID {
            TVSeriesDetailsScreen(viewModel: viewModel)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            TVSeriesDetailsScreen(viewModel: viewModel)
        }
    }

    @ViewBuilder
    private func personDetails(id: Int, transitionID: String?) -> some View {
        let viewModel = factory.makePersonDetails(id: id, navigator: navigator)
        if let transitionID {
            PersonDetailsScreen(viewModel: viewModel)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            PersonDetailsScreen(viewModel: viewModel)
        }
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
