//
//  DefaultFetchTVSeriesImageCollectionUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesApplication

// swiftlint:disable type_name
@Suite("DefaultFetchTVSeriesImageCollectionUseCaseTests")
struct DefaultFetchTVSeriesImageCollectionUseCaseTests {

    let mockRepository: MockTVSeriesRepository
    let mockAppConfigProvider: MockAppConfigurationProvider
    let mockAppConfiguration: AppConfiguration

    init() {
        self.mockRepository = MockTVSeriesRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        self.mockAppConfiguration = AppConfiguration.mock()

        mockAppConfigProvider.appConfigurationStub = .success(mockAppConfiguration)
    }

    @Test("execute should return image collection details")
    func execute_shouldReturnImageCollectionDetails() async throws {
        let id = 123
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        let result = try await useCase.execute(tvSeriesID: id)

        #expect(result.id == id)
        #expect(result.posterURLSets.count == imageCollection.posterPaths.count)
        #expect(result.backdropURLSets.count == imageCollection.backdropPaths.count)
        #expect(result.logoURLSets.count == imageCollection.logoPaths.count)
        #expect(mockRepository.imagesForTVSeriesCallCount == 1)
        #expect(mockAppConfigProvider.appConfigurationCallCount == 1)
    }

    @Test("execute should throw FetchTVSeriesImageCollectionError on repository failure")
    func execute_shouldThrowFetchTVSeriesImageCollectionErrorOnRepositoryFailure() async throws {
        let id = 101

        mockRepository.imagesForTVSeriesStub = .failure(.notFound)

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: id)
            },
            throws: { error in
                error is FetchTVSeriesImageCollectionError
            }
        )
    }

    @Test("execute should throw FetchTVSeriesImageCollectionError on app configuration failure")
    func execute_shouldThrowFetchTVSeriesImageCollectionErrorOnAppConfigurationFailure()
    async throws {
        let id = 303
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: id)
            },
            throws: { error in
                error is FetchTVSeriesImageCollectionError
            }
        )
    }

}

// swiftlint:enable type_name
