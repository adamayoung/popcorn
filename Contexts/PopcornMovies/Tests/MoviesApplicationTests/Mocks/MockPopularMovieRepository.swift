//
//  MockPopularMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

/// @unchecked Sendable is safe here: each test creates its own instance and
/// configures stubs before any concurrent access occurs. `popular(page:)` is
/// invoked once per `execute`, so its call tracking needs no lock.
final class MockPopularMovieRepository: PopularMovieRepository, @unchecked Sendable {

    var popularCallCount = 0
    var popularCalledWith: [Int] = []
    var popularStub: Result<MoviePreviewPage, PopularMovieRepositoryError>?

    func popular(page: Int) async throws(PopularMovieRepositoryError) -> MoviePreviewPage {
        popularCallCount += 1
        popularCalledWith.append(page)

        guard let stub = popularStub else {
            throw .notFound
        }

        switch stub {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { _ in }
    }

    func nextPopularStreamPage() async throws(PopularMovieRepositoryError) {}

}
