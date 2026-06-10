//
//  AppServices+Bundles.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import ConfigurationComposition
import CoreDomain
import DiscoverApplication
import DiscoverComposition
import GenresApplication
import GenresComposition
import MoviesApplication
import MoviesComposition
import PeopleApplication
import PeopleComposition
import TMDb
import TVSeriesApplication
import TVSeriesComposition

extension AppServices {

    /// Shared inputs threaded into every domain context factory.
    struct Foundations {
        let tmdb: TMDbClient
        let fetchAppConfiguration: any FetchAppConfigurationUseCase
        let themeColorProvider: (any ThemeColorProviding)?
    }

    struct ConfigurationBundle {
        let factory: PopcornConfigurationFactory
        let fetchAppConfiguration: any FetchAppConfigurationUseCase
    }

    struct GenresBundle {
        let factory: PopcornGenresFactory
        let fetchMovieGenres: any FetchMovieGenresUseCase
        let fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase
    }

    struct MoviesBundle {
        let factory: PopcornMoviesFactory
        let fetchDetails: any FetchMovieDetailsUseCase
        let fetchCredits: any FetchMovieCreditsUseCase
        let fetchRecommendations: any FetchMovieRecommendationsUseCase
        let fetchImageCollection: any FetchMovieImageCollectionUseCase
    }

    struct TVSeriesBundle {
        let factory: PopcornTVSeriesFactory
        let fetchDetails: any FetchTVSeriesDetailsUseCase
        let fetchImageCollection: any FetchTVSeriesImageCollectionUseCase
    }

    struct PeopleBundle {
        let factory: PopcornPeopleFactory
        let fetchDetails: any FetchPersonDetailsUseCase
    }

    struct DiscoverBundle {
        let factory: PopcornDiscoverFactory
        let fetchDiscoverMovies: any FetchDiscoverMoviesUseCase
    }

}
