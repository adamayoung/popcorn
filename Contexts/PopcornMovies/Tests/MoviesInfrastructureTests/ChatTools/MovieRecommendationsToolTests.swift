//
//  MovieRecommendationsToolTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
import Testing

@Suite("MovieRecommendationsTool Tests")
struct MovieRecommendationsToolTests {

    @Test("Tool should have correct name and description")
    func toolProperties() {
        let tool = MovieRecommendationsTool(
            movieID: 123,
            similarMovieRepository: MockSimilarMovieRepository()
        )

        #expect(tool.name == "getMovieRecommendations")
        #expect(!tool.description.isEmpty)
    }

    @Test("Tool should return formatted similar movies")
    func callReturnsFormattedRecommendations() async throws {
        let mockMovies = [
            MoviePreview(
                id: 1,
                title: "The Matrix",
                overview: "A computer hacker learns...",
                releaseDate: Date(timeIntervalSince1970: 922_838_400)
            ),
            MoviePreview(
                id: 2,
                title: "Inception",
                overview: "A thief who steals...",
                releaseDate: Date(timeIntervalSince1970: 1_279_065_600)
            )
        ]
        let mockRepository = MockSimilarMovieRepository(moviesToReturn: mockMovies)

        let tool = MovieRecommendationsTool(
            movieID: 550,
            similarMovieRepository: mockRepository
        )

        let result = try await tool.call(arguments: MovieRecommendationsTool.Arguments(limit: 5))

        #expect(result.contains("The Matrix"))
        #expect(result.contains("Inception"))
    }

    @Test("Tool should handle empty recommendations")
    func callHandlesEmptyRecommendations() async throws {
        let mockRepository = MockSimilarMovieRepository(moviesToReturn: [])

        let tool = MovieRecommendationsTool(
            movieID: 550,
            similarMovieRepository: mockRepository
        )

        let result = try await tool.call(arguments: MovieRecommendationsTool.Arguments(limit: 5))

        #expect(result == "No recommendations available")
    }

}

// MARK: - Mock SimilarMovieRepository

private final class MockSimilarMovieRepository: SimilarMovieRepository {

    private let moviesToReturn: [MoviePreview]
    private let shouldThrow: Bool

    init(moviesToReturn: [MoviePreview] = [], shouldThrow: Bool = false) {
        self.moviesToReturn = moviesToReturn
        self.shouldThrow = shouldThrow
    }

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview] {
        if shouldThrow {
            throw .notFound
        }
        return moviesToReturn
    }

    func similarStream(
        toMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }

    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(Array(moviesToReturn.prefix(limit ?? moviesToReturn.count)))
            continuation.finish()
        }
    }

    func nextSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieRepositoryError) {
        // No-op for mock
    }

}
