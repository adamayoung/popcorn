//
//  MockPopularMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure

actor MockPopularMovieLocalDataSource: PopularMovieLocalDataSource {

    nonisolated(unsafe) var popularCallCount = 0
    nonisolated(unsafe) var popularCalledWith: [Int] = []
    nonisolated(unsafe) var popularStub: Result<MoviePreviewPage?, PopularMovieLocalDataSourceError>?

    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> MoviePreviewPage? {
        popularCallCount += 1
        popularCalledWith.append(page)

        guard let stub = popularStub else {
            return nil
        }

        switch stub {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }

    nonisolated(unsafe) var popularStreamStub: AsyncThrowingStream<[MoviePreview]?, Error>?

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        popularStreamStub ?? AsyncThrowingStream { $0.finish() }
    }

    nonisolated(unsafe) var currentPopularStreamPageStub: Result<Int?, PopularMovieLocalDataSourceError>?

    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int? {
        guard let stub = currentPopularStreamPageStub else {
            return nil
        }

        switch stub {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }

    nonisolated(unsafe) var setPopularCallCount = 0
    nonisolated(unsafe) var setPopularCalledWith: [MoviePreviewPage] = []
    nonisolated(unsafe) var setPopularStub: Result<Void, PopularMovieLocalDataSourceError>?

    func setPopular(_ page: MoviePreviewPage) async throws(PopularMovieLocalDataSourceError) {
        setPopularCallCount += 1
        setPopularCalledWith.append(page)

        if case .failure(let error) = setPopularStub {
            throw error
        }
    }

}
