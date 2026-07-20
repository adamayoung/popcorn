//
//  DefaultFetchMovieDetailsUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

@Suite("DefaultFetchMovieDetailsUseCase Tests")
struct DefaultFetchMovieDetailsUseCaseTests {

    let mockMovieRepository: MockMovieRepository
    let mockImageRepository: MockMovieImageRepository
    let mockWatchlistRepository: MockMovieWatchlistRepository
    let mockAppConfigProvider: MockAppConfigurationProvider

    init() {
        self.mockMovieRepository = MockMovieRepository()
        self.mockImageRepository = MockMovieImageRepository()
        self.mockWatchlistRepository = MockMovieWatchlistRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        mockAppConfigProvider.appConfigurationStub = .success(.mock())
    }

    @Test("execute returns aggregated movie details on success")
    func executeReturnsMovieDetails() async throws {
        let id = 42
        mockMovieRepository.movieStubs[id] = .success(.mock(id: id, title: "Aggregated"))
        mockMovieRepository.certificationStub = .success("PG-13")
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .success(true)

        let useCase = makeUseCase()

        let result = try await useCase.execute(id: id)

        #expect(result.id == id)
        #expect(result.title == "Aggregated")
        #expect(result.certification == "PG-13")
        #expect(result.isOnWatchlist)
        #expect(result.logoURLSet != nil)
        #expect(result.posterURLSet != nil)
    }

    @Test("execute tolerates a certification failure")
    func executeToleratesCertificationFailure() async throws {
        let id = 7
        mockMovieRepository.movieStubs[id] = .success(.mock(id: id))
        mockMovieRepository.certificationStub = .failure(.notFound)
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .success(false)

        let useCase = makeUseCase()

        let result = try await useCase.execute(id: id)

        #expect(result.certification == nil)
    }

    @Test("execute does not apply a theme colour (kept off the critical path)")
    func executeAppliesNoThemeColor() async throws {
        let id = 7
        mockMovieRepository.movieStubs[id] = .success(.mock(id: id))
        mockMovieRepository.certificationStub = .success("PG")
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .success(false)

        let useCase = makeUseCase()

        let result = try await useCase.execute(id: id)

        #expect(result.themeColor == nil)
    }

    @Test("execute throws FetchMovieDetailsError on movie repository failure")
    func executeThrowsOnMovieFailure() async {
        let id = 99
        mockMovieRepository.movieStubs[id] = .failure(.notFound)
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .success(false)

        let useCase = makeUseCase()

        await #expect(
            performing: { try await useCase.execute(id: id) },
            throws: { $0 is FetchMovieDetailsError }
        )
    }

    @Test("execute throws FetchMovieDetailsError on watchlist repository failure")
    func executeThrowsOnWatchlistFailure() async {
        let id = 99
        mockMovieRepository.movieStubs[id] = .success(.mock(id: id))
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .failure(.unknown(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: { try await useCase.execute(id: id) },
            throws: { $0 is FetchMovieDetailsError }
        )
    }

    @Test("execute throws FetchMovieDetailsError on app configuration failure")
    func executeThrowsOnAppConfigurationFailure() async {
        let id = 99
        mockMovieRepository.movieStubs[id] = .success(.mock(id: id))
        mockImageRepository.imageCollectionStubs[id] = .success(.mock(id: id))
        mockWatchlistRepository.isOnWatchlistStub = .success(false)
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: { try await useCase.execute(id: id) },
            throws: { $0 is FetchMovieDetailsError }
        )
    }

}

extension DefaultFetchMovieDetailsUseCaseTests {

    func makeUseCase() -> DefaultFetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: mockMovieRepository,
            movieImageRepository: mockImageRepository,
            movieWatchlistRepository: mockWatchlistRepository,
            appConfigurationProvider: mockAppConfigProvider
        )
    }

}
