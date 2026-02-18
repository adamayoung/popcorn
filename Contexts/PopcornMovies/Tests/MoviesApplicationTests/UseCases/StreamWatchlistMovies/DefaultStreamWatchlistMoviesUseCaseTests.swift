//
//  DefaultStreamWatchlistMoviesUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

@Suite("DefaultStreamWatchlistMoviesUseCase")
struct DefaultStreamWatchlistMoviesUseCaseTests {

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

    @Test("stream emits movie preview details on success")
    func streamEmitsMoviePreviewDetailsOnSuccess() async throws {
        let watchlistMovie = WatchlistMovie.mock(id: 1)
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([watchlistMovie])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Inception"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
        #expect(results[0].count == 1)
        #expect(results[0][0].id == 1)
        #expect(results[0][0].title == "Inception")
    }

    @Test("stream emits empty array when watchlist is empty")
    func streamEmitsEmptyArrayWhenWatchlistIsEmpty() async throws {
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([])
            $0.finish()
        }
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
        #expect(results[0].isEmpty)
    }

    @Test("stream deduplicates identical emissions")
    func streamDeduplicatesIdenticalEmissions() async throws {
        let watchlistMovie = WatchlistMovie.mock(id: 1)
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([watchlistMovie])
            $0.yield([watchlistMovie])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Inception"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
    }

    @Test("stream skips individual movie fetch failures")
    func streamSkipsIndividualMovieFetchFailures() async throws {
        let movie1 = WatchlistMovie.mock(
            id: 1,
            createdAt: Date(timeIntervalSince1970: 2000)
        )
        let movie2 = WatchlistMovie.mock(
            id: 2,
            createdAt: Date(timeIntervalSince1970: 1000)
        )
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([movie1, movie2])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Success"))
        mockMovieRepository.movieStubs[2] = .failure(.notFound)
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
        #expect(results[0].count == 1)
        #expect(results[0][0].id == 1)
    }

    @Test("stream emits multiple updates for changing watchlist")
    func streamEmitsMultipleUpdatesForChangingWatchlist() async throws {
        let movie1 = WatchlistMovie.mock(id: 1)
        let movie2 = WatchlistMovie.mock(id: 2)
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([movie1])
            $0.yield([movie1, movie2])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Movie 1"))
        mockMovieRepository.movieStubs[2] = .success(.mock(id: 2, title: "Movie 2"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockImageRepository.imageCollectionStubs[2] = .success(.mock(id: 2))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 2)
        #expect(results[0].count == 1)
        #expect(results[1].count == 2)
    }

    @Test("stream skips emission when app configuration provider throws")
    func streamSkipsEmissionWhenAppConfigurationProviderThrows() async throws {
        let watchlistMovie = WatchlistMovie.mock(id: 1)
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([watchlistMovie])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Inception"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unknown(nil))

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.isEmpty)
    }

    @Test("stream recovers after transient config failure")
    func streamRecoversAfterTransientConfigFailure() async throws {
        let movie1 = WatchlistMovie.mock(id: 1)
        let movie2 = WatchlistMovie.mock(id: 2)
        mockWatchlistRepository.moviesStreamStub = AsyncThrowingStream {
            $0.yield([movie1])
            $0.yield([movie2])
            $0.finish()
        }
        mockMovieRepository.movieStubs[1] = .success(.mock(id: 1, title: "Movie 1"))
        mockMovieRepository.movieStubs[2] = .success(.mock(id: 2, title: "Movie 2"))
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockImageRepository.imageCollectionStubs[2] = .success(.mock(id: 2))
        mockAppConfigurationProvider.appConfigurationStubs = [
            .failure(.unknown(nil)),
            .success(.mock())
        ]

        let useCase = makeUseCase()
        let stream = await useCase.stream()

        var results: [[MoviePreviewDetails]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
        #expect(results[0].count == 1)
        #expect(results[0][0].id == 2)
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultStreamWatchlistMoviesUseCase {
        DefaultStreamWatchlistMoviesUseCase(
            movieRepository: mockMovieRepository,
            movieWatchlistRepository: mockWatchlistRepository,
            movieImageRepository: mockImageRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
