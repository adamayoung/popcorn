//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import Foundation
import GenresComposition
import GenresDomain
import TMDb

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

    public func makeGenresFactory() -> some PopcornGenresFactory {
        let genreRemoteDataSource = TMDbGenreRemoteDataSource(
            genreService: genreService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let genreBackdropProvider = GenreBackdropProviderAdapter(
            discoverService: discoverService
        )

        return LivePopcornGenresFactory(
            genreRemoteDataSource: genreRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            genreBackdropProvider: genreBackdropProvider
        )
    }

}
