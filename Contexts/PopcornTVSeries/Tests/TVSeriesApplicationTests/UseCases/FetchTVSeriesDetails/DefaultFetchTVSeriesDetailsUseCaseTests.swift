//
//  DefaultFetchTVSeriesDetailsUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesApplication

@Suite("DefaultFetchTVSeriesDetailsUseCaseTests")
struct DefaultFetchTVSeriesDetailsUseCaseTests {

    let mockRepository: MockTVSeriesRepository
    let mockAppConfigProvider: MockAppConfigurationProvider
    let mockAppConfiguration: AppConfiguration

    init() {
        self.mockRepository = MockTVSeriesRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        self.mockAppConfiguration = AppConfiguration.mock()

        mockAppConfigProvider.appConfigurationStub = .success(mockAppConfiguration)
    }

    @Test("execute should return TV series details")
    func execute_shouldReturnTVSeriesDetails() async throws {
        let id = 123
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        let result = try await useCase.execute(id: id)

        #expect(result.id == id)
        #expect(result.name == tvSeries.name)
        #expect(mockRepository.tvSeriesWithIDCallCount == 1)
        #expect(mockRepository.imagesForTVSeriesCallCount == 1)
        #expect(mockAppConfigProvider.appConfigurationCallCount == 1)
    }

    @Test("execute should throw FetchTVSeriesDetailsError on repository failure")
    func execute_shouldThrowFetchTVSeriesDetailsErrorOnRepositoryFailure() async throws {
        let id = 200

        mockRepository.tvSeriesWithIDStub = .failure(.notFound)

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await useCase.execute(id: id)
            },
            throws: { error in
                error is FetchTVSeriesDetailsError
            }
        )
    }

    @Test("execute should throw FetchTVSeriesDetailsError on app configuration failure")
    func execute_shouldThrowFetchTVSeriesDetailsErrorOnAppConfigurationFailure() async throws {
        let id = 400
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await useCase.execute(id: id)
            },
            throws: { error in
                error is FetchTVSeriesDetailsError
            }
        )
    }

}
