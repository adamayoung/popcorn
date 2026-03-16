//
//  DefaultFetchMovieWatchProvidersUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

struct DefaultFetchMovieWatchProvidersUseCaseTests {

    let mockRepository: MockMovieWatchProvidersRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockMovieWatchProvidersRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    // MARK: - execute() Tests

    @Test
    func `execute returns watch provider collection details on success`() async throws {
        let expectedCollection = WatchProviderCollection.mock()
        mockRepository.watchProvidersStub = .success(expectedCollection)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 123)

        let collection = try #require(result)
        #expect(collection.id == expectedCollection.id)
        #expect(collection.link == expectedCollection.link)
        #expect(collection.streamingProviders.count == expectedCollection.streamingProviders.count)
    }

    @Test
    func `execute returns nil when no providers available for region`() async throws {
        mockRepository.watchProvidersStub = .success(nil)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 123)

        #expect(result == nil)
    }

    @Test
    func `execute passes correct movie ID to repository`() async throws {
        mockRepository.watchProvidersStub = .success(nil)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(movieID: 456)

        #expect(mockRepository.watchProvidersCallCount == 1)
        #expect(mockRepository.watchProvidersCalledWith[0] == 456)
    }

    @Test
    func `execute throws not found error when repository throws not found`() async {
        mockRepository.watchProvidersStub = .failure(.notFound)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let watchProvidersError = error as? FetchMovieWatchProvidersError else {
                    return false
                }
                if case .notFound = watchProvidersError {
                    return true
                }
                return false
            }
        )
    }

    @Test
    func `execute throws unauthorised error when repository throws unauthorised`() async {
        mockRepository.watchProvidersStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let watchProvidersError = error as? FetchMovieWatchProvidersError else {
                    return false
                }
                if case .unauthorised = watchProvidersError {
                    return true
                }
                return false
            }
        )
    }

    @Test
    func `execute throws unknown error when repository throws unknown`() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.watchProvidersStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let watchProvidersError = error as? FetchMovieWatchProvidersError else {
                    return false
                }
                if case .unknown = watchProvidersError {
                    return true
                }
                return false
            }
        )
    }

    @Test
    func `execute throws unauthorised error when app configuration provider throws unauthorised`() async {
        mockRepository.watchProvidersStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let watchProvidersError = error as? FetchMovieWatchProvidersError else {
                    return false
                }
                if case .unauthorised = watchProvidersError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchMovieWatchProvidersUseCase {
        DefaultFetchMovieWatchProvidersUseCase(
            movieWatchProvidersRepository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
