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

    public init(genreRemoteDataSource: some GenreRemoteDataSource) {
        let infrastructureFactory = GenresInfrastructureFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
        self.applicationFactory = GenresApplicationFactory(
            genreRepository: infrastructureFactory.makeGenreRepository()
        )
    }

    public func makeFetchMovieGenresUseCase() -> FetchMovieGenresUseCase {
        applicationFactory.makeFetchMovieGenresUseCase()
    }

    public func makeFetchTVSeriesGenresUseCase() -> FetchTVSeriesGenresUseCase {
        applicationFactory.makeFetchTVSeriesGenresUseCase()
    }

}
