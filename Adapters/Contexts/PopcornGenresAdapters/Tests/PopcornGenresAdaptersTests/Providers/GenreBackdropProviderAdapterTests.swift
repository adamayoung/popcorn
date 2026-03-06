//
//  GenreBackdropProviderAdapterTests.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain
@testable import PopcornGenresAdapters
import Testing
import TMDb

@Suite("GenreBackdropProviderAdapter")
struct GenreBackdropProviderAdapterTests {

    let mockDiscoverService: MockDiscoverService

    init() {
        self.mockDiscoverService = MockDiscoverService()
    }

    @Test("returns first movie backdrop path")
    func returnsFirstMovieBackdropPath() async throws {
        let backdropPath = try #require(URL(string: "/action-backdrop.jpg"))
        let movie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "Overview",
            genreIDs: [28],
            releaseDate: Date(),
            posterPath: nil,
            backdropPath: backdropPath,
            popularity: 61.0,
            voteAverage: 8.4,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )
        mockDiscoverService.moviesStub = .success(
            MoviePageableList(page: 1, results: [movie], totalResults: 1, totalPages: 1)
        )

        let adapter = GenreBackdropProviderAdapter(discoverService: mockDiscoverService)

        let result = try await adapter.backdropPath(forGenreID: 28)

        #expect(result == backdropPath)
        #expect(mockDiscoverService.moviesCallCount == 1)
        #expect(mockDiscoverService.tvSeriesCallCount == 0)
    }

    @Test("falls back to TV series when movie has no backdrop")
    func fallsBackToTVSeriesWhenMovieHasNoBackdrop() async throws {
        let movie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "Overview",
            genreIDs: [28],
            releaseDate: Date(),
            posterPath: nil,
            backdropPath: nil,
            popularity: 61.0,
            voteAverage: 8.4,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )
        mockDiscoverService.moviesStub = .success(
            MoviePageableList(page: 1, results: [movie], totalResults: 1, totalPages: 1)
        )

        let tvBackdropPath = try #require(URL(string: "/tv-backdrop.jpg"))
        let tvSeries = TVSeriesListItem(
            id: 100,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "Overview",
            genreIDs: [28],
            firstAirDate: Date(),
            originCountries: ["US"],
            posterPath: nil,
            backdropPath: tvBackdropPath,
            popularity: 50.0,
            voteAverage: 8.9,
            voteCount: 10000,
            isAdultOnly: false
        )
        mockDiscoverService.tvSeriesStub = .success(
            TVSeriesPageableList(page: 1, results: [tvSeries], totalResults: 1, totalPages: 1)
        )

        let adapter = GenreBackdropProviderAdapter(discoverService: mockDiscoverService)

        let result = try await adapter.backdropPath(forGenreID: 28)

        #expect(result == tvBackdropPath)
        #expect(mockDiscoverService.moviesCallCount == 1)
        #expect(mockDiscoverService.tvSeriesCallCount == 1)
    }

    @Test("returns nil when neither movie nor TV has backdrop")
    func returnsNilWhenNeitherHasBackdrop() async throws {
        mockDiscoverService.moviesStub = .success(
            MoviePageableList(page: 1, results: [], totalResults: 0, totalPages: 1)
        )
        mockDiscoverService.tvSeriesStub = .success(
            TVSeriesPageableList(page: 1, results: [], totalResults: 0, totalPages: 1)
        )

        let adapter = GenreBackdropProviderAdapter(discoverService: mockDiscoverService)

        let result = try await adapter.backdropPath(forGenreID: 28)

        #expect(result == nil)
    }

    @Test("throws unauthorised when TMDb returns unauthorised")
    func throwsUnauthorisedWhenTMDbReturnsUnauthorised() async {
        mockDiscoverService.moviesStub = .failure(.unauthorised("No access"))

        let adapter = GenreBackdropProviderAdapter(discoverService: mockDiscoverService)

        await #expect(
            performing: {
                try await adapter.backdropPath(forGenreID: 28)
            },
            throws: { error in
                guard let providerError = error as? GenreBackdropProviderError else {
                    return false
                }
                if case .unauthorised = providerError {
                    return true
                }
                return false
            }
        )
    }

}
