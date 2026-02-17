//
//  MovieProviderAdapterSimilarMoviesTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverApplication
import DiscoverDomain
import Foundation
import MoviesApplication
import MoviesDomain
import PlotRemixGameDomain
@testable import PopcornPlotRemixGameAdapters
import Testing

@Suite("MovieProviderAdapter randomSimilarMovies Tests")
struct MovieProviderAdapterSimilarMoviesTests {

    @Test("randomSimilarMovies returns mapped movies from recommendations use case")
    func randomSimilarMoviesReturnsMappedMovies() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))

        let posterURLSet = try ImageURLSet(
            path: posterPath,
            thumbnail: #require(URL(string: "https://example.com/thumb.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let backdropURLSet = try ImageURLSet(
            path: backdropPath,
            thumbnail: #require(URL(string: "https://example.com/thumb.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let recommendedMovies = [
            MoviesApplication.MoviePreviewDetails(
                id: 551,
                title: "The Matrix",
                overview: "A computer hacker learns...",
                posterURLSet: posterURLSet,
                backdropURLSet: backdropURLSet
            )
        ]

        mockRecommendationsUseCase.executeStub = .success(recommendedMovies)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let result = try await adapter.randomSimilarMovies(to: 550, limit: 10)

        #expect(mockRecommendationsUseCase.executeCallCount == 1)
        #expect(mockRecommendationsUseCase.executeCalledWith.first?.movieID == 550)
        #expect(result.count == 1)
        #expect(result[0].id == 551)
        #expect(result[0].title == "The Matrix")
        #expect(result[0].posterPath == posterPath)
        #expect(result[0].backdropPath == backdropPath)
    }

    @Test("randomSimilarMovies limits results to specified count")
    func randomSimilarMoviesLimitsResults() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        let movies = (1 ... 20).map { id in
            MoviesApplication.MoviePreviewDetails(
                id: id,
                title: "Movie \(id)",
                overview: "Overview \(id)"
            )
        }

        mockRecommendationsUseCase.executeStub = .success(movies)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let result = try await adapter.randomSimilarMovies(to: 550, limit: 5)

        #expect(result.count == 5)
    }

    @Test("randomSimilarMovies throws unauthorised error")
    func randomSimilarMoviesThrowsUnauthorisedError() async {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockRecommendationsUseCase.executeStub = .failure(.unauthorised)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        await #expect(
            performing: {
                try await adapter.randomSimilarMovies(to: 550, limit: 10)
            },
            throws: { error in
                guard let error = error as? MovieProviderError else {
                    return false
                }
                if case .unauthorised = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("randomSimilarMovies throws unknown error for notFound")
    func randomSimilarMoviesThrowsUnknownErrorForNotFound() async {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockRecommendationsUseCase.executeStub = .failure(.notFound)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        await #expect(
            performing: {
                try await adapter.randomSimilarMovies(to: 550, limit: 10)
            },
            throws: { error in
                guard let error = error as? MovieProviderError else {
                    return false
                }
                if case .unknown = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("randomSimilarMovies throws unknown error")
    func randomSimilarMoviesThrowsUnknownError() async {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockRecommendationsUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        await #expect(
            performing: {
                try await adapter.randomSimilarMovies(to: 550, limit: 10)
            },
            throws: { error in
                guard let error = error as? MovieProviderError else {
                    return false
                }
                if case .unknown = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("randomSimilarMovies returns empty array when no recommendations found")
    func randomSimilarMoviesReturnsEmptyArrayWhenNoRecommendationsFound() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockRecommendationsUseCase.executeStub = .success([])

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let result = try await adapter.randomSimilarMovies(to: 550, limit: 10)

        #expect(result.isEmpty)
    }

    @Test("randomSimilarMovies passes correct movieID to use case")
    func randomSimilarMoviesPassesCorrectMovieID() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockRecommendationsUseCase.executeStub = .success([])

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        _ = try await adapter.randomSimilarMovies(to: 12345, limit: 5)

        #expect(mockRecommendationsUseCase.executeCallCount == 1)
        #expect(mockRecommendationsUseCase.executeCalledWith.first?.movieID == 12345)
    }

}

// MARK: - Test Helpers

private extension MovieProviderAdapterSimilarMoviesTests {

    struct TestError: Error {}

}
