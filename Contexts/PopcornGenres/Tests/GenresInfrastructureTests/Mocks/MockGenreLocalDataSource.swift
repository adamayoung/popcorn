//
//  MockGenreLocalDataSource.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain
import GenresInfrastructure

actor MockGenreLocalDataSource: GenreLocalDataSource {

    var movieGenresCallCount = 0
    nonisolated(unsafe) var movieGenresStub: Result<[Genre]?, GenreLocalDataSourceError>?

    func movieGenres() async throws(GenreLocalDataSourceError) -> [Genre]? {
        movieGenresCallCount += 1

        guard let stub = movieGenresStub else {
            return nil
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

    var setMovieGenresCallCount = 0
    var setMovieGenresCalledWith: [[Genre]] = []
    nonisolated(unsafe) var setMovieGenresStub: Result<Void, GenreLocalDataSourceError>?

    func setMovieGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError) {
        setMovieGenresCallCount += 1
        setMovieGenresCalledWith.append(genres)

        if case .failure(let error) = setMovieGenresStub {
            throw error
        }
    }

    var tvSeriesGenresCallCount = 0
    nonisolated(unsafe) var tvSeriesGenresStub: Result<[Genre]?, GenreLocalDataSourceError>?

    func tvSeriesGenres() async throws(GenreLocalDataSourceError) -> [Genre]? {
        tvSeriesGenresCallCount += 1

        guard let stub = tvSeriesGenresStub else {
            return nil
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

    var setTVSeriesGenresCallCount = 0
    var setTVSeriesGenresCalledWith: [[Genre]] = []
    nonisolated(unsafe) var setTVSeriesGenresStub: Result<Void, GenreLocalDataSourceError>?

    func setTVSeriesGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError) {
        setTVSeriesGenresCallCount += 1
        setTVSeriesGenresCalledWith.append(genres)

        if case .failure(let error) = setTVSeriesGenresStub {
            throw error
        }
    }

}
