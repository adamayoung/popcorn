//
//  DefaultFetchTVSeriesAggregateCreditsUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("DefaultFetchTVSeriesAggregateCreditsUseCase")
struct DefaultFetchTVSeriesAggregateCreditsUseCaseTests {

    let mockRepository: MockTVSeriesCreditsRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockTVSeriesCreditsRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    // MARK: - execute() Tests

    @Test("execute returns aggregate credits details on success")
    func executeReturnsAggregateCreditsDetailsOnSuccess() async throws {
        let expectedCredits = AggregateCredits.mock()
        mockRepository.aggregateCreditsStub = .success(expectedCredits)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 66732)

        #expect(result.id == expectedCredits.id)
        #expect(result.cast.count == expectedCredits.cast.count)
        #expect(result.crew.count == expectedCredits.crew.count)
    }

    @Test("execute passes correct TV series ID to repository")
    func executePassesCorrectTVSeriesIDToRepository() async throws {
        mockRepository.aggregateCreditsStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(tvSeriesID: 456)

        #expect(mockRepository.aggregateCreditsCallCount == 1)
        #expect(mockRepository.aggregateCreditsCalledWith[0] == 456)
    }

    @Test("execute throws not found error when repository throws not found")
    func executeThrowsNotFoundWhenRepositoryThrowsNotFound() async {
        mockRepository.aggregateCreditsStub = .failure(.notFound)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchTVSeriesAggregateCreditsError else {
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
        mockRepository.aggregateCreditsStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchTVSeriesAggregateCreditsError else {
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
        mockRepository.aggregateCreditsStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchTVSeriesAggregateCreditsError else {
                    return false
                }
                if case .unknown = creditsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unauthorised when app config provider throws unauthorised")
    func executeThrowsUnauthorisedWhenAppConfigProviderThrowsUnauthorised() async {
        mockRepository.aggregateCreditsStub = .success(.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let creditsError = error as? FetchTVSeriesAggregateCreditsError else {
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

    private func makeUseCase() -> DefaultFetchTVSeriesAggregateCreditsUseCase {
        DefaultFetchTVSeriesAggregateCreditsUseCase(
            tvSeriesCreditsRepository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
