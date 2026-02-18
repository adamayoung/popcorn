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

    package init(genreRepository: some GenreRepository) {
        self.genreRepository = genreRepository
    }

    package func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        DefaultFetchMovieGenresUseCase(repository: genreRepository)
    }

    package func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        DefaultFetchTVSeriesGenresUseCase(repository: genreRepository)
    }

}
