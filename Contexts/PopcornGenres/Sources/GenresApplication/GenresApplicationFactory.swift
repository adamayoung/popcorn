//
//  GenresApplicationFactory.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GenresDomain

package final class GenresApplicationFactory {

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
