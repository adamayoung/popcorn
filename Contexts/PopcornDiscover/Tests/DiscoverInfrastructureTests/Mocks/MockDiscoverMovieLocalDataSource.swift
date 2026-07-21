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
    nonisolated(unsafe) var moviesStub: Result<MoviePreviewPage?, DiscoverMovieLocalDataSourceError>?

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) -> MoviePreviewPage? {
        moviesCallCount += 1
        moviesCalledWith.append((filter: filter, page: page))

        guard let stub = moviesStub else {
            return nil
        }

        switch stub {
        case .success(let moviePage):
            return moviePage
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
    var setMoviesCalledWith: [(page: MoviePreviewPage, filter: MovieFilter?)] = []
    nonisolated(unsafe) var setMoviesStub: Result<Void, DiscoverMovieLocalDataSourceError>?

    func setMovies(
        _ page: MoviePreviewPage,
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) {
        setMoviesCallCount += 1
        setMoviesCalledWith.append((page: page, filter: filter))

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
