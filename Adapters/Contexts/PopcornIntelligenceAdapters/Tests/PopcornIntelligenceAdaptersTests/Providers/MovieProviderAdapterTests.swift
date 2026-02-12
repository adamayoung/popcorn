//
//  MovieProviderAdapterTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
import MoviesApplication
@testable import PopcornIntelligenceAdapters
import Testing

@Suite("MovieProviderAdapter Tests")
struct MovieProviderAdapterTests {

    @Test("Returns mapped movie when use case succeeds")
    func returnsMappedMovieWhenUseCaseSucceeds() async throws {
        let posterURLSet = try makeImageURLSet(path: "poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "backdrop.jpg")
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)

        let movieDetails = MovieDetails(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac...",
            releaseDate: releaseDate,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            isOnWatchlist: false
        )

        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .success(movieDetails)

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        let result = try await adapter.movie(withID: 550)

        #expect(mockUseCase.executeCalledWithID == 550)
        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac...")
        #expect(result.releaseDate == releaseDate)
        #expect(result.posterPath == posterURLSet.path)
        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Throws notFound error when use case throws notFound")
    func throwsNotFoundErrorWhenUseCaseThrowsNotFound() async throws {
        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .failure(.notFound)

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        var thrownError: MovieProviderError?
        do {
            _ = try await adapter.movie(withID: 999)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 999)
        let error = try #require(thrownError)
        guard case .notFound = error else {
            Issue.record("Expected notFound error but got \(error)")
            return
        }
    }

    @Test("Throws unauthorised error when use case throws unauthorised")
    func throwsUnauthorisedErrorWhenUseCaseThrowsUnauthorised() async throws {
        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .failure(.unauthorised)

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        var thrownError: MovieProviderError?
        do {
            _ = try await adapter.movie(withID: 550)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 550)
        let error = try #require(thrownError)
        guard case .unauthorised = error else {
            Issue.record("Expected unauthorised error but got \(error)")
            return
        }
    }

    @Test("Throws unknown error when use case throws unknown")
    func throwsUnknownErrorWhenUseCaseThrowsUnknown() async throws {
        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .failure(.unknown(TestError.generic))

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        var thrownError: MovieProviderError?
        do {
            _ = try await adapter.movie(withID: 550)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 550)
        let error = try #require(thrownError)
        guard case .unknown = error else {
            Issue.record("Expected unknown error but got \(error)")
            return
        }
    }

    @Test("Passes correct movie ID to use case")
    func passesCorrectMovieIDToUseCase() async throws {
        let movieDetails = MovieDetails(
            id: 12345,
            title: "Test Movie",
            overview: "Test overview",
            isOnWatchlist: false
        )

        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .success(movieDetails)

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        _ = try await adapter.movie(withID: 12345)

        #expect(mockUseCase.executeCalledWithID == 12345)
    }

    @Test("Maps movie with nil optional fields correctly")
    func mapsMoveWithNilOptionalFieldsCorrectly() async throws {
        let movieDetails = MovieDetails(
            id: 550,
            title: "Fight Club",
            overview: "An overview",
            releaseDate: nil,
            posterURLSet: nil,
            backdropURLSet: nil,
            isOnWatchlist: true
        )

        let mockUseCase = MockFetchMovieDetailsUseCase()
        mockUseCase.result = .success(movieDetails)

        let adapter = MovieProviderAdapter(fetchMovieDetailsUseCase: mockUseCase)

        let result = try await adapter.movie(withID: 550)

        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

}

// MARK: - Test Helpers

extension MovieProviderAdapterTests {

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

}

// MARK: - Test Error

private enum TestError: Error {
    case generic
}
