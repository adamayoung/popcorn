//
//  GenreProviderAdapterTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import GenresApplication
import GenresDomain
@testable import PopcornDiscoverAdapters
import Testing

@Suite("GenreProviderAdapter Tests")
struct GenreProviderAdapterTests {

    let mockFetchMovieGenresUseCase: MockFetchMovieGenresUseCase
    let mockFetchTVSeriesGenresUseCase: MockFetchTVSeriesGenresUseCase

    init() {
        self.mockFetchMovieGenresUseCase = MockFetchMovieGenresUseCase()
        self.mockFetchTVSeriesGenresUseCase = MockFetchTVSeriesGenresUseCase()
    }

    // MARK: - Movie Genres Tests

    @Test("movieGenres returns genres from use case")
    func movieGenres_returnsGenresFromUseCase() async throws {
        let genres: [GenresDomain.Genre] = [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation")
        ]

        mockFetchMovieGenresUseCase.executeStub = .success(genres)

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        let result = try await adapter.movieGenres()

        #expect(mockFetchMovieGenresUseCase.executeCallCount == 1)
        #expect(result.count == 3)
        #expect(result[0].id == 28)
        #expect(result[0].name == "Action")
        #expect(result[1].id == 12)
        #expect(result[1].name == "Adventure")
        #expect(result[2].id == 16)
        #expect(result[2].name == "Animation")
    }

    @Test("movieGenres returns empty array when use case returns empty")
    func movieGenres_returnsEmptyArrayWhenUseCaseReturnsEmpty() async throws {
        mockFetchMovieGenresUseCase.executeStub = .success([])

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        let result = try await adapter.movieGenres()

        #expect(result.isEmpty)
    }

    @Test("movieGenres throws unauthorised error from use case")
    func movieGenres_throwsUnauthorisedErrorFromUseCase() async {
        mockFetchMovieGenresUseCase.executeStub = .failure(.unauthorised)

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        await #expect(
            performing: {
                try await adapter.movieGenres()
            },
            throws: { error in
                guard let error = error as? GenreProviderError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movieGenres throws unknown error from use case for unknown error")
    func movieGenres_throwsUnknownErrorFromUseCaseForUnknownError() async {
        mockFetchMovieGenresUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        await #expect(
            performing: {
                try await adapter.movieGenres()
            },
            throws: { error in
                guard let error = error as? GenreProviderError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    // MARK: - TV Series Genres Tests

    @Test("tvSeriesGenres returns genres from use case")
    func tvSeriesGenres_returnsGenresFromUseCase() async throws {
        let genres: [GenresDomain.Genre] = [
            Genre(id: 10759, name: "Action & Adventure"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 35, name: "Comedy")
        ]

        mockFetchTVSeriesGenresUseCase.executeStub = .success(genres)

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        let result = try await adapter.tvSeriesGenres()

        #expect(mockFetchTVSeriesGenresUseCase.executeCallCount == 1)
        #expect(result.count == 3)
        #expect(result[0].id == 10759)
        #expect(result[0].name == "Action & Adventure")
        #expect(result[1].id == 16)
        #expect(result[1].name == "Animation")
        #expect(result[2].id == 35)
        #expect(result[2].name == "Comedy")
    }

    @Test("tvSeriesGenres returns empty array when use case returns empty")
    func tvSeriesGenres_returnsEmptyArrayWhenUseCaseReturnsEmpty() async throws {
        mockFetchTVSeriesGenresUseCase.executeStub = .success([])

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        let result = try await adapter.tvSeriesGenres()

        #expect(result.isEmpty)
    }

    @Test("tvSeriesGenres throws unauthorised error from use case")
    func tvSeriesGenres_throwsUnauthorisedErrorFromUseCase() async {
        mockFetchTVSeriesGenresUseCase.executeStub = .failure(.unauthorised)

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        await #expect(
            performing: {
                try await adapter.tvSeriesGenres()
            },
            throws: { error in
                guard let error = error as? GenreProviderError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeriesGenres throws unknown error from use case for unknown error")
    func tvSeriesGenres_throwsUnknownErrorFromUseCaseForUnknownError() async {
        mockFetchTVSeriesGenresUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = GenreProviderAdapter(
            fetchMovieGenresUseCase: mockFetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: mockFetchTVSeriesGenresUseCase
        )

        await #expect(
            performing: {
                try await adapter.tvSeriesGenres()
            },
            throws: { error in
                guard let error = error as? GenreProviderError else {
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

// MARK: - Test Helpers

private extension GenreProviderAdapterTests {

    struct TestError: Error {}

}
