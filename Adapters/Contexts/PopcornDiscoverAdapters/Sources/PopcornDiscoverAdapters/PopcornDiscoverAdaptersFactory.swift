//
//  PopcornDiscoverAdaptersFactory.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import DiscoverDomain
import DiscoverInfrastructure
import GenresApplication
import MoviesApplication
import TMDb
import TVSeriesApplication

/// Builds the Discover context's TMDb-backed adapters (port implementations).
///
/// This factory is responsible only for adapting external services to the
/// Discover context's ports. Assembling the context's factory from these adapters
/// is the composition root's responsibility, so the adapters layer stays a leaf
/// and never depends on the context's composition module.
public final class PopcornDiscoverAdaptersFactory {

    private let discoverService: any DiscoverService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    public init(
        discoverService: some DiscoverService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        fetchTVSeriesGenresUseCase: some FetchTVSeriesGenresUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase
    ) {
        self.discoverService = discoverService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.fetchTVSeriesGenresUseCase = fetchTVSeriesGenresUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    public func makeDiscoverRemoteDataSource() -> some DiscoverRemoteDataSource {
        TMDbDiscoverRemoteDataSource(discoverService: discoverService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeGenreProvider() -> some GenreProviding {
        GenreProviderAdapter(
            fetchMovieGenresUseCase: fetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: fetchTVSeriesGenresUseCase
        )
    }

    public func makeMovieLogoImageProvider() -> some MovieLogoImageProviding {
        MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: fetchMovieImageCollectionUseCase)
    }

    public func makeTVSeriesLogoImageProvider() -> some TVSeriesLogoImageProviding {
        TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollectionUseCase
        )
    }

}
