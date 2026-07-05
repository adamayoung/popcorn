//
//  DefaultFetchTrendingTVSeriesUseCaseErrorTests.swift
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

@Suite("DefaultFetchTrendingTVSeriesUseCase Error Cases")
struct DefaultFetchTrendingTVSeriesUseCaseErrorTests {

    let mockRepository: MockTrendingRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockTrendingRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    @Test("execute throws unauthorised when repository throws unauthorised")
    func executeThrowsUnauthorisedWhenRepositoryThrowsUnauthorised() async {
        mockRepository.tvSeriesStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingTVSeriesError else {
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
        mockRepository.tvSeriesStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingTVSeriesError else {
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
        mockRepository.tvSeriesStub = .success(TVSeriesPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingTVSeriesError else {
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
        mockRepository.tvSeriesStub = .success(TVSeriesPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTrendingTVSeriesError else {
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

    private func makeUseCase() -> DefaultFetchTrendingTVSeriesUseCase {
        DefaultFetchTrendingTVSeriesUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
