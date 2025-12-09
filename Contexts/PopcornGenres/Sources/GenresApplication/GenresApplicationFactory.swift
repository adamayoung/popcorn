//
//  GenresApplicationFactory.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GenresDomain

public final class GenresApplicationFactory {

    private let genreRepository: any GenreRepository

    init(genreRepository: some GenreRepository) {
        self.genreRepository = genreRepository
    }

    public func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        DefaultFetchMovieGenresUseCase(repository: genreRepository)
    }

    public func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        DefaultFetchTVSeriesGenresUseCase(repository: genreRepository)
    }

}
