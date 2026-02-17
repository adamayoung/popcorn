//
//  GenresApplicationFactory.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

public final class GenresApplicationFactory: Sendable {

    private let genreRepository: any GenreRepository

    public init(genreRepository: some GenreRepository) {
        self.genreRepository = genreRepository
    }

    public func makeFetchMovieGenresUseCase() -> some FetchMovieGenresUseCase {
        DefaultFetchMovieGenresUseCase(repository: genreRepository)
    }

    public func makeFetchTVSeriesGenresUseCase() -> some FetchTVSeriesGenresUseCase {
        DefaultFetchTVSeriesGenresUseCase(repository: genreRepository)
    }

}
