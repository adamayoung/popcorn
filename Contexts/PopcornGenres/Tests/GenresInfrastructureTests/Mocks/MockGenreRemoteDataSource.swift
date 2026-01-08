//
//  MockGenreRemoteDataSource.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
import GenresInfrastructure

final class MockGenreRemoteDataSource: GenreRemoteDataSource, @unchecked Sendable {

    var movieGenresCallCount = 0
    var movieGenresStub: Result<[Genre], GenreRemoteDataSourceError>?

    func movieGenres() async throws(GenreRemoteDataSourceError) -> [Genre] {
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
    var tvSeriesGenresStub: Result<[Genre], GenreRemoteDataSourceError>?

    func tvSeriesGenres() async throws(GenreRemoteDataSourceError) -> [Genre] {
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
