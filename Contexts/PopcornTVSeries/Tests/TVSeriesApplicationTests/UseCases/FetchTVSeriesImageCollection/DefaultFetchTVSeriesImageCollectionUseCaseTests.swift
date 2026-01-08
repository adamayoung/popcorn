//
//  DefaultFetchTVSeriesImageCollectionUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain

@testable import TVSeriesApplication

@Suite("DefaultFetchTVSeriesImageCollectionUseCaseTests")
struct DefaultFetchTVSeriesImageCollectionUseCaseTests {

    let mockRepository: MockTVSeriesRepository
    let mockAppConfigProvider: MockAppConfigurationProvider
    let mockObservabilityProvider: MockObservabilityProvider
    let mockAppConfiguration: AppConfiguration

    init() {
        self.mockRepository = MockTVSeriesRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        self.mockObservabilityProvider = MockObservabilityProvider()
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

    @Test("execute should create span with correct operation")
    func execute_shouldCreateSpanWithCorrectOperation() async throws {
        let id = 456
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(tvSeriesID: id)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.useCaseExecute.value)
        #expect(
            mockSpan.startChildCalledWith[0].description
                == "FetchTVSeriesImageCollectionUseCase.execute")
    }

    @Test("execute should finish span with ok status on success")
    func execute_shouldFinishSpanWithOkStatusOnSuccess() async throws {
        let id = 789
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(tvSeriesID: id)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
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

    @Test(
        "execute should set error on span and finish with internal error on repository failure")
    func execute_shouldSetErrorOnSpanAndFinishWithInternalErrorOnRepositoryFailure() async throws {
        let id = 202
        let mockSpan = MockSpan()

        mockRepository.imagesForTVSeriesStub = .failure(.notFound)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await useCase.execute(tvSeriesID: id)
                }
            },
            throws: { _ in true }
        )

        #expect(mockSpan.setDataCallCount >= 1)
        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should throw FetchTVSeriesImageCollectionError on app configuration failure")
    func execute_shouldThrowFetchTVSeriesImageCollectionErrorOnAppConfigurationFailure()
    async throws {
        let id = 303
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await useCase.execute(tvSeriesID: id)
                }
            },
            throws: { error in
                error is FetchTVSeriesImageCollectionError
            }
        )
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should succeed without span")
    func execute_shouldSucceedWithoutSpan() async throws {
        let id = 404
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        SpanContext.provider = nil

        let useCase = DefaultFetchTVSeriesImageCollectionUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        let result = try await useCase.execute(tvSeriesID: id)

        #expect(result.id == id)
        #expect(result.posterURLSets.count == imageCollection.posterPaths.count)
        #expect(result.backdropURLSets.count == imageCollection.backdropPaths.count)
        #expect(result.logoURLSets.count == imageCollection.logoPaths.count)
    }

}
