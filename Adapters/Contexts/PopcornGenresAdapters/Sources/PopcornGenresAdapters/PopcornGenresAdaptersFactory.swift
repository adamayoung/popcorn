//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import GenresDomain
import GenresInfrastructure
import TMDb

/// Builds the Genres context's TMDb-backed adapters (port implementations).
public final class PopcornGenresAdaptersFactory {

    private let genreService: any GenreService
    private let discoverService: any DiscoverService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        genreService: some GenreService,
        discoverService: some DiscoverService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.genreService = genreService
        self.discoverService = discoverService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeGenreRemoteDataSource() -> some GenreRemoteDataSource {
        TMDbGenreRemoteDataSource(genreService: genreService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeGenreBackdropProvider() -> some GenreBackdropProviding {
        GenreBackdropProviderAdapter(discoverService: discoverService)
    }

}
