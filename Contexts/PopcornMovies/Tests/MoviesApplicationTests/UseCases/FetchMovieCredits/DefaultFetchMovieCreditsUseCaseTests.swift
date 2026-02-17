//
//  DefaultFetchMovieCreditsUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

@Suite("DefaultFetchMovieCreditsUseCase")
struct DefaultFetchMovieCreditsUseCaseTests {

    let mockRepository: MockMovieCreditsRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockMovieCreditsRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    // MARK: - execute() Tests

    @Test("execute returns credits details on success")
    func executeReturnsCreditsDetailsOnSuccess() async throws {
        let expectedCredits = Credits.mock()
        mockRepository.creditsStub = .success(expectedCredits)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 123)

        #expect(result.id == expectedCredits.id)
        #expect(result.cast.count == expectedCredits.cast.count)
        #expect(result.crew.count == expectedCredits.crew.count)
    }

    @Test("execute passes correct movie ID to repository")
    func executePassesCorrectMovieIDToRepository() async throws {
        mockRepository.creditsStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(movieID: 456)

        #expect(mockRepository.creditsCallCount == 1)
        #expect(mockRepository.creditsCalledWith[0] == 456)
    }

    @Test("execute throws not found error when repository throws not found")
    func executeThrowsNotFoundWhenRepositoryThrowsNotFound() async {
        mockRepository.creditsStub = .failure(.notFound)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchMovieCreditsError else {
                    return false
                }
                if case .notFound = creditsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedWhenRepositoryThrowsUnauthorised() async {
        mockRepository.creditsStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchMovieCreditsError else {
                    return false
                }
                if case .unauthorised = creditsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown error when repository throws unknown")
    func executeThrowsUnknownWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.creditsStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchMovieCreditsError else {
                    return false
                }
                if case .unknown = creditsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unauthorised error when app configuration provider throws unauthorised")
    func executeThrowsUnauthorisedWhenAppConfigProviderThrowsUnauthorised() async {
        mockRepository.creditsStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchMovieCreditsError else {
                    return false
                }
                if case .unauthorised = creditsError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchMovieCreditsUseCase {
        DefaultFetchMovieCreditsUseCase(
            movieCreditsRepository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
