//
//  DefaultFetchWatchlistMoviesUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

@Suite("DefaultFetchWatchlistMoviesUseCase")
struct DefaultFetchWatchlistMoviesUseCaseTests {

    let mockMovieRepository: MockMovieRepository
    let mockWatchlistRepository: MockMovieWatchlistRepository
    let mockImageRepository: MockMovieImageRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockMovieRepository = MockMovieRepository()
        self.mockWatchlistRepository = MockMovieWatchlistRepository()
        self.mockImageRepository = MockMovieImageRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    @Test("execute returns movie preview details on success")
    func executeReturnsMoviePreviewDetailsOnSuccess() async throws {
        let watchlistMovie = WatchlistMovie.mock(id: 1)
        mockWatchlistRepository.moviesStub = .success([watchlistMovie])
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Inception"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == 1)
        #expect(result[0].id == 1)
        #expect(result[0].title == "Inception")
    }

    @Test("execute returns empty array when watchlist is empty")
    func executeReturnsEmptyArrayWhenWatchlistIsEmpty() async throws {
        mockWatchlistRepository.moviesStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.isEmpty)
    }

    @Test("execute sorts results by createdAt descending")
    func executeSortsResultsByCreatedAtDescending() async throws {
        let oldest = WatchlistMovie.mock(id: 1, createdAt: Date(timeIntervalSince1970: 1000))
        let middle = WatchlistMovie.mock(id: 2, createdAt: Date(timeIntervalSince1970: 2000))
        let newest = WatchlistMovie.mock(id: 3, createdAt: Date(timeIntervalSince1970: 3000))
        mockWatchlistRepository.moviesStub = .success([oldest, middle, newest])
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Oldest"))
        mockMovieRepository.movieStubs[2] = .success(.mock(id: 2, title: "Middle"))
        mockMovieRepository.movieStubs[3] = .success(.mock(id: 3, title: "Newest"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockImageRepository.imageCollectionStubs[2] = .success(.mock(id: 2))
        mockImageRepository.imageCollectionStubs[3] = .success(.mock(id: 3))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == 3)
        #expect(result[0].id == 3)
        #expect(result[1].id == 2)
        #expect(result[2].id == 1)
    }

    @Test("execute throws unknown error when watchlist repository fails")
    func executeThrowsUnknownErrorWhenWatchlistRepositoryFails() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockWatchlistRepository.moviesStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let watchlistError = error as? FetchWatchlistMoviesError else {
                    return false
                }
                if case .unknown = watchlistError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute skips movies that fail to fetch individually")
    func executeSkipsMoviesThatFailToFetchIndividually() async throws {
        let movie1 = WatchlistMovie.mock(id: 1, createdAt: Date(timeIntervalSince1970: 2000))
        let movie2 = WatchlistMovie.mock(id: 2, createdAt: Date(timeIntervalSince1970: 1000))
        mockWatchlistRepository.moviesStub = .success([movie1, movie2])
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Success Movie"))
        mockMovieRepository.movieStubs[2] = .failure(.notFound)
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == 1)
        #expect(result[0].id == 1)
        #expect(result[0].title == "Success Movie")
    }

    @Test("execute throws when app configuration provider fails")
    func executeThrowsWhenAppConfigurationProviderFails() async {
        let watchlistMovie = WatchlistMovie.mock(id: 1)
        mockWatchlistRepository.moviesStub = .success([watchlistMovie])
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unknown(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let watchlistError = error as? FetchWatchlistMoviesError else {
                    return false
                }
                if case .unknown = watchlistError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchWatchlistMoviesUseCase {
        DefaultFetchWatchlistMoviesUseCase(
            movieRepository: mockMovieRepository,
            movieWatchlistRepository: mockWatchlistRepository,
            movieImageRepository: mockImageRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
