//
//  MovieDetailsToolTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
import Testing

@Suite("MovieDetailsTool Tests")
struct MovieDetailsToolTests {

    @Test("Tool should have correct name and description")
    func toolProperties() {
        let tool = MovieDetailsTool(
            movieID: 123,
            movieRepository: MockMovieRepository()
        )

        #expect(tool.name == "getMovieDetails")
        #expect(!tool.description.isEmpty)
    }

    @Test("Tool should return formatted movie details")
    func callReturnsFormattedDetails() async throws {
        let mockMovie = Movie(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            releaseDate: Date(timeIntervalSince1970: 939_600_000)
        )
        let mockRepository = MockMovieRepository(movieToReturn: mockMovie)

        let tool = MovieDetailsTool(
            movieID: 550,
            movieRepository: mockRepository
        )

        let result = try await tool.call(arguments: MovieDetailsTool.Arguments())

        #expect(result.contains("Fight Club"))
        #expect(result.contains("A ticking-time-bomb insomniac"))
    }

    @Test("Tool should handle repository errors")
    func callHandlesRepositoryError() async throws {
        let mockRepository = MockMovieRepository(shouldThrow: true)

        let tool = MovieDetailsTool(
            movieID: 999,
            movieRepository: mockRepository
        )

        await #expect(throws: MovieRepositoryError.self) {
            try await tool.call(arguments: MovieDetailsTool.Arguments())
        }
    }

}

// MARK: - Mock MovieRepository

private final class MockMovieRepository: MovieRepository {

    private let movieToReturn: Movie?
    private let shouldThrow: Bool

    init(movieToReturn: Movie? = nil, shouldThrow: Bool = false) {
        self.movieToReturn = movieToReturn
        self.shouldThrow = shouldThrow
    }

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        if shouldThrow {
            throw .notFound
        }

        guard let movie = movieToReturn else {
            throw .notFound
        }

        return movie
    }

    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }

}
