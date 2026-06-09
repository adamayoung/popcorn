//
//  ViewModelFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import GamesCatalogFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import PlotRemixGameFeature
import TVListingsFeature
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

}
