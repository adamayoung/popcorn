//
//  MediaProviderAdapterMovieTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
import PeopleApplication
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TVSeriesApplication

@Suite("MediaProviderAdapter Movie Tests")
struct MediaProviderAdapterMovieTests {

    let mockFetchMovieUseCase: MockFetchMovieDetailsUseCase
    let mockFetchTVSeriesUseCase: MockFetchTVSeriesDetailsUseCase
    let mockFetchPersonUseCase: MockFetchPersonDetailsUseCase

    init() {
        self.mockFetchMovieUseCase = MockFetchMovieDetailsUseCase()
        self.mockFetchTVSeriesUseCase = MockFetchTVSeriesDetailsUseCase()
        self.mockFetchPersonUseCase = MockFetchPersonDetailsUseCase()
    }

    @Test("movie returns MoviePreview from use case")
    func movieReturnsMoviePreviewFromUseCase() async throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let posterURLSet = makeImageURLSet(path: posterPath)
        let backdropURLSet = makeImageURLSet(path: backdropPath)

        let movieDetails = MovieDetails(
            id: 123,
            title: "Test Movie",
            overview: "A test movie overview",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            isOnWatchlist: false
        )

        mockFetchMovieUseCase.executeStub = .success(movieDetails)

        let adapter = makeAdapter()

        let result = try await adapter.movie(withID: 123)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.overview == "A test movie overview")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
        #expect(mockFetchMovieUseCase.executeCallCount == 1)
        #expect(mockFetchMovieUseCase.executeCalledWith[0].id == 123)
    }

    @Test("movie returns MoviePreview with nil URLs when URLSets are nil")
    func movieReturnsMoviePreviewWithNilURLsWhenURLSetsAreNil() async throws {
        let movieDetails = MovieDetails(
            id: 456,
            title: "Minimal Movie",
            overview: "A minimal movie",
            posterURLSet: nil,
            backdropURLSet: nil,
            isOnWatchlist: false
        )

        mockFetchMovieUseCase.executeStub = .success(movieDetails)

        let adapter = makeAdapter()

        let result = try await adapter.movie(withID: 456)

        #expect(result.id == 456)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("movie throws notFound error from use case")
    func movieThrowsNotFoundErrorFromUseCase() async {
        mockFetchMovieUseCase.executeStub = .failure(.notFound)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.movie(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movie throws unauthorised error from use case")
    func movieThrowsUnauthorisedErrorFromUseCase() async {
        mockFetchMovieUseCase.executeStub = .failure(.unauthorised)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.movie(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movie throws unknown error from use case")
    func movieThrowsUnknownErrorFromUseCase() async {
        mockFetchMovieUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.movie(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

}

private extension MediaProviderAdapterMovieTests {

    struct TestError: Error {}

    func makeAdapter() -> MediaProviderAdapter {
        MediaProviderAdapter(
            fetchMovieUseCase: mockFetchMovieUseCase,
            fetchTVSeriesUseCase: mockFetchTVSeriesUseCase,
            fetchPersonUseCase: mockFetchPersonUseCase
        )
    }

    func makeImageURLSet(path: URL) -> ImageURLSet {
        ImageURLSet(
            path: path,
            thumbnail: path,
            card: path,
            detail: path,
            full: path
        )
    }

}
