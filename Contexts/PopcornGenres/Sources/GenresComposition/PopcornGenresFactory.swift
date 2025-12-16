//
//  PopcornGenresFactory.swift
//  PopcornGenres
//
//  Created by Adam Young on 15/12/2025.
//

import Foundation
import GenresApplication
import GenresDomain
import GenresInfrastructure

public final class PopcornGenresFactory {

    private let applicationFactory: GenresApplicationFactory

    public init(genreRemoteDataSource: some GenreRemoteDataSource) {
        let infrastructureFactory = GenresInfrastructureFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
        self.applicationFactory = GenresApplicationFactory(
            genreRepository: infrastructureFactory.makeGenreRepository()
        )
    }

    public func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        applicationFactory.makeFetchMovieGenresUseCase()
    }

    public func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        applicationFactory.makeFetchTVSeriesGenresUseCase()
    }

}
