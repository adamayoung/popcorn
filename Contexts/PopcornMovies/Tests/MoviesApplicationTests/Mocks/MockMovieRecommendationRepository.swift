//
//  MockMovieRecommendationRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

/// @unchecked Sendable is safe here: each test creates its own instance and
/// configures stubs before any concurrent access occurs. `recommendations(forMovie:page:)`
/// is invoked once per `execute`, so its call tracking needs no lock.
final class MockMovieRecommendationRepository: MovieRecommendationRepository, @unchecked Sendable {

    var recommendationsCallCount = 0
    var recommendationsCalledWith: [(movieID: Int, page: Int)] = []
    var recommendationsStub: Result<[MoviePreview], MovieRecommendationRepositoryError>?

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationRepositoryError) -> [MoviePreview] {
        recommendationsCallCount += 1
        recommendationsCalledWith.append((movieID, page))

        guard let stub = recommendationsStub else {
            throw .notFound
        }

        switch stub {
        case .success(let moviePreviews):
            return moviePreviews
        case .failure(let error):
            throw error
        }
    }

    func recommendationsStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { _ in }
    }

    func recommendationsStream(
        forMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { _ in }
    }

    func nextRecommendationsStreamPage(
        forMovie movieID: Int
    ) async throws(MovieRecommendationRepositoryError) {}

}
