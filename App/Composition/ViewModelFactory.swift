//
//  ViewModelFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
#if DEBUG
    import DeveloperFeature
#endif
import ExploreFeature
import GamesCatalogFeature
import MediaSearchFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import PlotRemixGameFeature
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVListingsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature
import WatchlistFeature

/// Builds feature view models from the app's shared ``AppServices`` graph.
///
/// The App-layer composition seam for the TCA→MVVM migration: each migrated tab
/// adds `make*` methods here that wire a feature's `Dependencies.live(services:)`
/// to a navigator supplied by the tab's router. Grows one method per leaf as more
/// tabs migrate.
@MainActor
final class ViewModelFactory {

    private let services: AppServices

    init(services: AppServices) {
        self.services = services
    }

    // MARK: - Games

    func makeGamesCatalog(
        navigator: some GamesCatalogNavigating
    ) -> GamesCatalogViewModel {
        GamesCatalogViewModel(
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    func makePlotRemixGame(
        gameID: Int,
        navigator: some PlotRemixGameNavigating
    ) -> PlotRemixGameViewModel {
        PlotRemixGameViewModel(
            gameID: gameID,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - Explore

    func makeExplore(
        navigator: some ExploreNavigating
    ) -> ExploreViewModel {
        ExploreViewModel(
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Listings

    func makeTVListings() -> TVListingsViewModel {
        TVListingsViewModel(dependencies: .live(services: services))
    }

    // MARK: - Watchlist

    func makeWatchlist(
        navigator: some WatchlistNavigating
    ) -> WatchlistViewModel {
        WatchlistViewModel(
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - Movie Details

    func makeMovieDetails(
        id: Int,
        transitionID: String?,
        navigator: some MovieDetailsNavigating
    ) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            movieID: id,
            transitionID: transitionID,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - Person Details

    func makePersonDetails(
        id: Int,
        navigator: some PersonDetailsNavigating
    ) -> PersonDetailsViewModel {
        PersonDetailsViewModel(
            personID: id,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - Movie Cast & Crew

    func makeMovieCastAndCrew(
        movieID: Int,
        navigator: some MovieCastAndCrewNavigating
    ) -> MovieCastAndCrewViewModel {
        MovieCastAndCrewViewModel(
            movieID: movieID,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - Movie Intelligence

    func makeMovieIntelligence(
        movieID: Int
    ) -> MovieIntelligenceViewModel {
        MovieIntelligenceViewModel(
            movieID: movieID,
            dependencies: .live(services: services)
        )
    }

    // MARK: - Media Search

    func makeMediaSearch(
        navigator: some MediaSearchNavigating
    ) -> MediaSearchViewModel {
        MediaSearchViewModel(
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Series Details

    func makeTVSeriesDetails(
        id: Int,
        navigator: some TVSeriesDetailsNavigating
    ) -> TVSeriesDetailsViewModel {
        TVSeriesDetailsViewModel(
            tvSeriesID: id,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Season Details

    func makeTVSeasonDetails(
        tvSeriesID: Int,
        seasonNumber: Int,
        navigator: some TVSeasonDetailsNavigating
    ) -> TVSeasonDetailsViewModel {
        TVSeasonDetailsViewModel(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Episode Details

    func makeTVEpisodeDetails(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        navigator: some TVEpisodeDetailsNavigating
    ) -> TVEpisodeDetailsViewModel {
        TVEpisodeDetailsViewModel(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Series Cast & Crew

    func makeTVSeriesCastAndCrew(
        tvSeriesID: Int,
        navigator: some TVSeriesCastAndCrewNavigating
    ) -> TVSeriesCastAndCrewViewModel {
        TVSeriesCastAndCrewViewModel(
            tvSeriesID: tvSeriesID,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Episode Cast & Crew

    func makeTVEpisodeCastAndCrew(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        navigator: some TVEpisodeCastAndCrewNavigating
    ) -> TVEpisodeCastAndCrewViewModel {
        TVEpisodeCastAndCrewViewModel(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }

    // MARK: - TV Series Intelligence

    func makeTVSeriesIntelligence(
        tvSeriesID: Int
    ) -> TVSeriesIntelligenceViewModel {
        TVSeriesIntelligenceViewModel(
            tvSeriesID: tvSeriesID,
            dependencies: .live(services: services)
        )
    }

    #if DEBUG
        // MARK: - Feature Flags (Developer)

        func makeFeatureFlags() -> FeatureFlagsViewModel {
            FeatureFlagsViewModel(dependencies: .live(services: services))
        }
    #endif

}
