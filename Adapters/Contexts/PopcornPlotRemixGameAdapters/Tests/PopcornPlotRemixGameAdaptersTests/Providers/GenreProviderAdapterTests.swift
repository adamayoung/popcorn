//
//  GenreProviderAdapterTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain
import PlotRemixGameDomain
@testable import PopcornPlotRemixGameAdapters
import Testing

@Suite("GenreProviderAdapter Tests")
struct GenreProviderAdapterTests {

    @Test("movies returns mapped genres from use case")
    func moviesReturnsMappedGenres() async throws {
        let mockUseCase = MockFetchMovieGenresUseCase()

        let genresFromUseCase = [
            GenresDomain.Genre(id: 28, name: "Action"),
            GenresDomain.Genre(id: 18, name: "Drama"),
            GenresDomain.Genre(id: 35, name: "Comedy")
        ]

        mockUseCase.executeStub = .success(genresFromUseCase)

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        let result = try await adapter.movies()

        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.count == 3)
        #expect(result[0].id == 28)
        #expect(result[0].name == "Action")
        #expect(result[1].id == 18)
        #expect(result[1].name == "Drama")
        #expect(result[2].id == 35)
        #expect(result[2].name == "Comedy")
    }

    @Test("movies returns empty array when no genres found")
    func moviesReturnsEmptyArrayWhenNoGenresFound() async throws {
        let mockUseCase = MockFetchMovieGenresUseCase()

        mockUseCase.executeStub = .success([])

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        let result = try await adapter.movies()

        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isEmpty)
    }

    @Test("movies throws unauthorised error")
    func moviesThrowsUnauthorisedError() async {
        let mockUseCase = MockFetchMovieGenresUseCase()

        mockUseCase.executeStub = .failure(.unauthorised)

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.movies()
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

    @Test("movies throws unknown error")
    func moviesThrowsUnknownError() async {
        let mockUseCase = MockFetchMovieGenresUseCase()

        mockUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.movies()
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

    @Test("movies correctly maps genre properties")
    func moviesCorrectlyMapsGenreProperties() async throws {
        let mockUseCase = MockFetchMovieGenresUseCase()

        let genresFromUseCase = [
            GenresDomain.Genre(id: 12, name: "Adventure"),
            GenresDomain.Genre(id: 16, name: "Animation"),
            GenresDomain.Genre(id: 99, name: "Documentary")
        ]

        mockUseCase.executeStub = .success(genresFromUseCase)

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        let result = try await adapter.movies()

        for (index, genre) in result.enumerated() {
            #expect(genre.id == genresFromUseCase[index].id)
            #expect(genre.name == genresFromUseCase[index].name)
        }
    }

    @Test("movies returns non-empty result when genres exist")
    func moviesReturnsNonEmptyResultWhenGenresExist() async throws {
        let mockUseCase = MockFetchMovieGenresUseCase()

        mockUseCase.executeStub = .success([
            GenresDomain.Genre(id: 28, name: "Action")
        ])

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        let result = try await adapter.movies()

        #expect(result.first != nil)
        #expect(result.first?.id == 28)
        #expect(result.first?.name == "Action")
    }

    @Test("movies preserves genre order from use case")
    func moviesPreservesGenreOrderFromUseCase() async throws {
        let mockUseCase = MockFetchMovieGenresUseCase()

        let genresFromUseCase = [
            GenresDomain.Genre(id: 1, name: "First"),
            GenresDomain.Genre(id: 2, name: "Second"),
            GenresDomain.Genre(id: 3, name: "Third"),
            GenresDomain.Genre(id: 4, name: "Fourth"),
            GenresDomain.Genre(id: 5, name: "Fifth")
        ]

        mockUseCase.executeStub = .success(genresFromUseCase)

        let adapter = GenreProviderAdapter(fetchMovieGenresUseCase: mockUseCase)

        let result = try await adapter.movies()

        #expect(result.count == 5)
        for (index, genre) in result.enumerated() {
            #expect(genre.id == index + 1)
            #expect(genre.name == genresFromUseCase[index].name)
        }
    }

}

// MARK: - Test Helpers

private extension GenreProviderAdapterTests {

    struct TestError: Error {}

}
