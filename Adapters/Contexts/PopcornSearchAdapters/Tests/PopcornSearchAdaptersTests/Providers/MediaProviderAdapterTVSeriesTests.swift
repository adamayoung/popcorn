//
//  MediaProviderAdapterTVSeriesTests.swift
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

@Suite("MediaProviderAdapter TVSeries Tests")
struct MediaProviderAdapterTVSeriesTests {

    let mockFetchMovieUseCase: MockFetchMovieDetailsUseCase
    let mockFetchTVSeriesUseCase: MockFetchTVSeriesDetailsUseCase
    let mockFetchPersonUseCase: MockFetchPersonDetailsUseCase

    init() {
        self.mockFetchMovieUseCase = MockFetchMovieDetailsUseCase()
        self.mockFetchTVSeriesUseCase = MockFetchTVSeriesDetailsUseCase()
        self.mockFetchPersonUseCase = MockFetchPersonDetailsUseCase()
    }

    @Test("tvSeries returns TVSeriesPreview from use case")
    func tvSeriesReturnsTVSeriesPreviewFromUseCase() async throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let posterURLSet = makeImageURLSet(path: posterPath)
        let backdropURLSet = makeImageURLSet(path: backdropPath)

        let tvSeriesDetails = TVSeriesDetails(
            id: 789,
            name: "Test TV Series",
            overview: "A test TV series overview",
            numberOfSeasons: 3,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        mockFetchTVSeriesUseCase.executeStub = .success(tvSeriesDetails)

        let adapter = makeAdapter()

        let result = try await adapter.tvSeries(withID: 789)

        #expect(result.id == 789)
        #expect(result.name == "Test TV Series")
        #expect(result.overview == "A test TV series overview")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
        #expect(mockFetchTVSeriesUseCase.executeCallCount == 1)
        #expect(mockFetchTVSeriesUseCase.executeCalledWith[0].id == 789)
    }

    @Test("tvSeries returns TVSeriesPreview with nil URLs when URLSets are nil")
    func tvSeriesReturnsTVSeriesPreviewWithNilURLsWhenURLSetsAreNil() async throws {
        let tvSeriesDetails = TVSeriesDetails(
            id: 101,
            name: "Minimal TV Series",
            overview: "A minimal TV series",
            numberOfSeasons: 1,
            posterURLSet: nil,
            backdropURLSet: nil
        )

        mockFetchTVSeriesUseCase.executeStub = .success(tvSeriesDetails)

        let adapter = makeAdapter()

        let result = try await adapter.tvSeries(withID: 101)

        #expect(result.id == 101)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("tvSeries throws notFound error from use case")
    func tvSeriesThrowsNotFoundErrorFromUseCase() async {
        mockFetchTVSeriesUseCase.executeStub = .failure(.notFound)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.tvSeries(withID: 999)
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

    @Test("tvSeries throws unauthorised error from use case")
    func tvSeriesThrowsUnauthorisedErrorFromUseCase() async {
        mockFetchTVSeriesUseCase.executeStub = .failure(.unauthorised)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.tvSeries(withID: 999)
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

    @Test("tvSeries throws unknown error from use case")
    func tvSeriesThrowsUnknownErrorFromUseCase() async {
        mockFetchTVSeriesUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.tvSeries(withID: 999)
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

private extension MediaProviderAdapterTVSeriesTests {

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
