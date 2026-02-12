//
//  MovieProviderAdapterRandomMoviesTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
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

@Suite("MovieProviderAdapter randomMovies Tests")
struct MovieProviderAdapterRandomMoviesTests {

    @Test("randomMovies returns mapped movies from discover use case")
    func randomMoviesReturnsMappedMovies() async throws {
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

        let discoverMovies = [
            DiscoverApplication.MoviePreviewDetails(
                id: 550,
                title: "Fight Club",
                overview: "A ticking-time-bomb insomniac...",
                releaseDate: Date(),
                genres: [],
                posterURLSet: posterURLSet,
                backdropURLSet: backdropURLSet
            )
        ]

        mockDiscoverUseCase.executeWithFilterStub = .success(discoverMovies)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        let result = try await adapter.randomMovies(filter: filter, limit: 10)

        #expect(mockDiscoverUseCase.executeWithFilterCallCount == 1)
        #expect(result.count == 1)
        #expect(result[0].id == 550)
        #expect(result[0].title == "Fight Club")
        #expect(result[0].posterPath == posterPath)
        #expect(result[0].backdropPath == backdropPath)
    }

    @Test("randomMovies passes correct filter to use case")
    func randomMoviesPassesCorrectFilter() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockDiscoverUseCase.executeWithFilterStub = .success([])

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "fr",
            genres: [28, 18],
            primaryReleaseYear: .fromYear(2000)
        )

        _ = try await adapter.randomMovies(filter: filter, limit: 5)

        #expect(mockDiscoverUseCase.executeWithFilterCallCount == 1)
        let calledFilter = try #require(mockDiscoverUseCase.executeWithFilterCalledWith.first?.filter)
        #expect(calledFilter.originalLanguage == "fr")
        #expect(calledFilter.genres == [28, 18])
        #expect(calledFilter.primaryReleaseYear == .fromYear(2000))
    }

    @Test("randomMovies limits results to specified count")
    func randomMoviesLimitsResults() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        let movies = (1 ... 20).map { id in
            DiscoverApplication.MoviePreviewDetails(
                id: id,
                title: "Movie \(id)",
                overview: "Overview \(id)",
                releaseDate: Date(),
                genres: []
            )
        }

        mockDiscoverUseCase.executeWithFilterStub = .success(movies)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        let result = try await adapter.randomMovies(filter: filter, limit: 5)

        #expect(result.count == 5)
    }

    @Test("randomMovies throws unauthorised error")
    func randomMoviesThrowsUnauthorisedError() async {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockDiscoverUseCase.executeWithFilterStub = .failure(.unauthorised)

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        await #expect(
            performing: {
                try await adapter.randomMovies(filter: filter, limit: 10)
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

    @Test("randomMovies throws unknown error")
    func randomMoviesThrowsUnknownError() async {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockDiscoverUseCase.executeWithFilterStub = .failure(.unknown(TestError()))

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        await #expect(
            performing: {
                try await adapter.randomMovies(filter: filter, limit: 10)
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

    @Test("randomMovies returns empty array when no movies found")
    func randomMoviesReturnsEmptyArrayWhenNoMoviesFound() async throws {
        let mockDiscoverUseCase = MockFetchDiscoverMoviesUseCase()
        let mockRecommendationsUseCase = MockFetchMovieRecommendationsUseCase()

        mockDiscoverUseCase.executeWithFilterStub = .success([])

        let adapter = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: mockDiscoverUseCase,
            fetchMovieRecommendationsUseCase: mockRecommendationsUseCase
        )

        let filter = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        let result = try await adapter.randomMovies(filter: filter, limit: 10)

        #expect(result.isEmpty)
    }

}

// MARK: - Test Helpers

private extension MovieProviderAdapterRandomMoviesTests {

    struct TestError: Error {}

}
