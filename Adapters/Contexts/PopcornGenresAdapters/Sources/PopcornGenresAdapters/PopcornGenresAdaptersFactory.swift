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
///
/// This factory is responsible only for adapting external services to the
/// Genres context's ports. Assembling the context's factory from these adapters
/// is the composition root's responsibility, so the adapters layer stays a leaf
/// and never depends on the context's composition module.
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
