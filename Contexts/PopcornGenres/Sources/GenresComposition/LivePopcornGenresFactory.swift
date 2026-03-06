//
//  LivePopcornGenresFactory.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain
import GenresInfrastructure

public final class LivePopcornGenresFactory: PopcornGenresFactory {

    private let applicationFactory: GenresApplicationFactory

    public init(
        genreRemoteDataSource: some GenreRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        genreBackdropProvider: some GenreBackdropProviding
    ) {
        let infrastructureFactory = GenresInfrastructureFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
        self.applicationFactory = GenresApplicationFactory(
            genreRepository: infrastructureFactory.makeGenreRepository(),
            appConfigurationProvider: appConfigurationProvider,
            genreBackdropProvider: genreBackdropProvider
        )
    }

    public func makeFetchMovieGenresUseCase() -> FetchMovieGenresUseCase {
        applicationFactory.makeFetchMovieGenresUseCase()
    }

    public func makeFetchTVSeriesGenresUseCase() -> FetchTVSeriesGenresUseCase {
        applicationFactory.makeFetchTVSeriesGenresUseCase()
    }

    public func makeFetchAllGenresUseCase() -> FetchAllGenresUseCase {
        applicationFactory.makeFetchAllGenresUseCase()
    }

}
