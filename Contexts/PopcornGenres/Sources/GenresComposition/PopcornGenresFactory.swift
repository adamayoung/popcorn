//
//  PopcornGenresFactory.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain
import GenresInfrastructure

///
/// Factory for creating genre-related use cases.
///
/// This factory serves as the main entry point for the PopcornGenres module,
/// composing the application, domain, and infrastructure layers to provide
/// fully configured use cases for fetching movie and TV series genres.
///
public final class PopcornGenresFactory {

    private let applicationFactory: GenresApplicationFactory

    ///
    /// Creates a new factory instance.
    ///
    /// - Parameter genreRemoteDataSource: The remote data source for fetching genre data from an API.
    ///
    public init(genreRemoteDataSource: some GenreRemoteDataSource) {
        let infrastructureFactory = GenresInfrastructureFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
        self.applicationFactory = GenresApplicationFactory(
            genreRepository: infrastructureFactory.makeGenreRepository()
        )
    }

    ///
    /// Creates a use case for fetching movie genres.
    ///
    /// - Returns: A configured ``FetchMovieGenresUseCase`` instance.
    ///
    public func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        applicationFactory.makeFetchMovieGenresUseCase()
    }

    ///
    /// Creates a use case for fetching TV series genres.
    ///
    /// - Returns: A configured ``FetchTVSeriesGenresUseCase`` instance.
    ///
    public func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        applicationFactory.makeFetchTVSeriesGenresUseCase()
    }

}
