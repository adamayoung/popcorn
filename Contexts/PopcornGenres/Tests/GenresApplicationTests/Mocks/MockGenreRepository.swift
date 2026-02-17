//
//  MockGenreRepository.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

final class MockGenreRepository: GenreRepository, @unchecked Sendable {

    var movieGenresCallCount = 0
    var movieGenresStub: Result<[Genre], GenreRepositoryError>?

    func movieGenres() async throws(GenreRepositoryError) -> [Genre] {
        movieGenresCallCount += 1

        guard let stub = movieGenresStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

    var tvSeriesGenresCallCount = 0
    var tvSeriesGenresStub: Result<[Genre], GenreRepositoryError>?

    func tvSeriesGenres() async throws(GenreRepositoryError) -> [Genre] {
        tvSeriesGenresCallCount += 1

        guard let stub = tvSeriesGenresStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

}
