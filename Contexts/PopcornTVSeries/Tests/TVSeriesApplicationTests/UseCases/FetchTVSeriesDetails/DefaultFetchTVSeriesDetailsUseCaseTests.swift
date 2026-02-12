//
//  DefaultFetchTVSeriesDetailsUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("DefaultFetchTVSeriesDetailsUseCaseTests")
struct DefaultFetchTVSeriesDetailsUseCaseTests {

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

    @Test("execute should create span with correct operation")
    func execute_shouldCreateSpanWithCorrectOperation() async throws {
        let id = 456
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(id: id)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.useCaseExecute.value
        )
        #expect(
            mockSpan.startChildCalledWith[0].description == "FetchTVSeriesDetailsUseCase.execute"
        )
    }

    @Test("execute should set TV series ID on span")
    func execute_shouldSetTVSeriesIDOnSpan() async throws {
        let id = 789
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(id: id)
        }

        #expect(mockSpan.setDataCallCount >= 1)
        let tvSeriesIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "tv_series_id" })
        #expect(tvSeriesIDEntry != nil)
        #expect(tvSeriesIDEntry?.value == "\(id)")
    }

    @Test("execute should finish span with ok status on success")
    func execute_shouldFinishSpanWithOkStatusOnSuccess() async throws {
        let id = 100
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(id: id)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("execute should throw FetchTVSeriesDetailsError on repository failure")
    func execute_shouldThrowFetchTVSeriesDetailsErrorOnRepositoryFailure() async {
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

    @Test("execute should set error on span and finish with internal error on repository failure")
    func execute_shouldSetErrorOnSpanAndFinishWithInternalErrorOnRepositoryFailure() async {
        let id = 300
        let mockSpan = MockSpan()

        mockRepository.tvSeriesWithIDStub = .failure(.notFound)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await useCase.execute(id: id)
                }
            },
            throws: { _ in true }
        )

        #expect(mockSpan.setDataCallCount >= 2)
        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should throw FetchTVSeriesDetailsError on app configuration failure")
    func execute_shouldThrowFetchTVSeriesDetailsErrorOnAppConfigurationFailure() async {
        let id = 400
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)
        let mockSpan = MockSpan()

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await useCase.execute(id: id)
                }
            },
            throws: { error in
                error is FetchTVSeriesDetailsError
            }
        )
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should succeed without span")
    func execute_shouldSucceedWithoutSpan() async throws {
        let id = 500
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        mockRepository.tvSeriesWithIDStub = .success(tvSeries)
        mockRepository.imagesForTVSeriesStub = .success(imageCollection)

        SpanContext.provider = nil

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        let result = try await useCase.execute(id: id)

        #expect(result.id == id)
        #expect(result.name == tvSeries.name)
    }

}
