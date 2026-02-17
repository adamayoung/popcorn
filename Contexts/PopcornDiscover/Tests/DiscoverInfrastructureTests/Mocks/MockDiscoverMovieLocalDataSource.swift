//
//  MockDiscoverMovieLocalDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation

actor MockDiscoverMovieLocalDataSource: DiscoverMovieLocalDataSource {

    var moviesCallCount = 0
    var moviesCalledWith: [(filter: MovieFilter?, page: Int)] = []
    nonisolated(unsafe) var moviesStub: Result<[MoviePreview]?, DiscoverMovieLocalDataSourceError>?

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) -> [MoviePreview]? {
        moviesCallCount += 1
        moviesCalledWith.append((filter: filter, page: page))

        guard let stub = moviesStub else {
            return nil
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    var moviesStreamCallCount = 0
    nonisolated(unsafe) var moviesStreamStub: AsyncThrowingStream<[MoviePreview]?, Error>?

    func moviesStream(
        filter: MovieFilter?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        moviesStreamCallCount += 1
        return moviesStreamStub ?? AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }

    var currentMoviesStreamPageCallCount = 0
    nonisolated(unsafe) var currentMoviesStreamPageStub: Result<Int?, DiscoverMovieLocalDataSourceError>?

    func currentMoviesStreamPage(
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) -> Int? {
        currentMoviesStreamPageCallCount += 1

        guard let stub = currentMoviesStreamPageStub else {
            return nil
        }

        switch stub {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }

    var setMoviesCallCount = 0
    var setMoviesCalledWith: [(movies: [MoviePreview], filter: MovieFilter?, page: Int)] = []
    nonisolated(unsafe) var setMoviesStub: Result<Void, DiscoverMovieLocalDataSourceError>?

    func setMovies(
        _ moviePreviews: [MoviePreview],
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) {
        setMoviesCallCount += 1
        setMoviesCalledWith.append((movies: moviePreviews, filter: filter, page: page))

        guard let stub = setMoviesStub else {
            return
        }

        switch stub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

}
