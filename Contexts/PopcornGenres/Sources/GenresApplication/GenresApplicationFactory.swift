//
//  GenresApplicationFactory.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

package final class GenresApplicationFactory: Sendable {

    private let genreRepository: any GenreRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let genreBackdropProvider: any GenreBackdropProviding

    package init(
        genreRepository: some GenreRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        genreBackdropProvider: some GenreBackdropProviding
    ) {
        self.genreRepository = genreRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.genreBackdropProvider = genreBackdropProvider
    }

    package func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        DefaultFetchMovieGenresUseCase(repository: genreRepository)
    }

    package func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        DefaultFetchTVSeriesGenresUseCase(repository: genreRepository)
    }

    package func makeFetchAllGenresUseCase() -> some FetchAllGenresUseCase {
        DefaultFetchAllGenresUseCase(
            repository: genreRepository,
            appConfigurationProvider: appConfigurationProvider,
            genreBackdropProvider: genreBackdropProvider
        )
    }

}
