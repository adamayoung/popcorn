//
//  DefaultFetchTrendingMoviesUseCaseErrorTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("DefaultFetchTrendingMoviesUseCase Error Cases")
struct DefaultFetchTrendingMoviesUseCaseErrorTests {

    let mockRepository: MockTrendingRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockLogoImageProvider: MockMovieLogoImageProvider

    init() {
        self.mockRepository = MockTrendingRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockLogoImageProvider = MockMovieLogoImageProvider()
    }

    @Test("execute throws unauthorised when repository throws unauthorised")
    func executeThrowsUnauthorisedWhenRepositoryThrowsUnauthorised() async {
        mockRepository.moviesStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingMoviesError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when repository throws unknown")
    func executeThrowsUnknownWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.moviesStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingMoviesError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unauthorised when app configuration provider throws unauthorised")
    func executeThrowsUnauthorisedWhenAppConfigurationProviderThrowsUnauthorised() async {
        mockRepository.moviesStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingMoviesError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when app configuration provider throws unknown")
    func executeThrowsUnknownWhenAppConfigurationProviderThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockRepository.moviesStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingMoviesError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchTrendingMoviesUseCase {
        DefaultFetchTrendingMoviesUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider,
            logoImageProvider: mockLogoImageProvider
        )
    }

}
