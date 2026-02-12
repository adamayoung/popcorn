//
//  MockGenresService.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb

final class MockGenresService: GenreService, @unchecked Sendable {

    struct MovieGenresCall: Equatable {
        let language: String?
    }

    struct TVSeriesGenresCall: Equatable {
        let language: String?
    }

    var movieGenresCallCount = 0
    var movieGenresCalledWith: [MovieGenresCall] = []
    var movieGenresStub: Result<[Genre], TMDbError>?

    var tvSeriesGenresCallCount = 0
    var tvSeriesGenresCalledWith: [TVSeriesGenresCall] = []
    var tvSeriesGenresStub: Result<[Genre], TMDbError>?

    func movieGenres(language: String?) async throws -> [Genre] {
        movieGenresCallCount += 1
        movieGenresCalledWith.append(MovieGenresCall(language: language))

        guard let stub = movieGenresStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

    func tvSeriesGenres(language: String?) async throws -> [Genre] {
        tvSeriesGenresCallCount += 1
        tvSeriesGenresCalledWith.append(TVSeriesGenresCall(language: language))

        guard let stub = tvSeriesGenresStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

}
