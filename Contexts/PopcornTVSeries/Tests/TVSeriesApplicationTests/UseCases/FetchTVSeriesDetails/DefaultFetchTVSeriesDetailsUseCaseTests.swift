//
//  DefaultFetchTVSeriesDetailsUseCaseTests.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 18/12/2025.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain
import Testing

@testable import TVSeriesApplication

@Suite("DefaultFetchTVSeriesDetailsUseCaseTests")
struct DefaultFetchTVSeriesDetailsUseCaseTests {

    // MARK: - Test 1: Execute Successfully Returns TVSeriesDetails

    @Test func executeSuccessfullyReturnsTVSeriesDetails() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 123))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 123))
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        let result = try await useCase.execute(id: 123)

        // Assert
        #expect(result.id == 123)
        #expect(result.name == "Breaking Bad")
        #expect(mockRepository.tvSeriesWithIDCallCount == 1)
        #expect(mockRepository.imagesForTVSeriesCallCount == 1)
        #expect(mockAppConfigProvider.appConfigurationCallCount == 1)
    }

    // MARK: - Test 2: Execute Creates Span with Correct Operation

    @Test func executeCreatesSpanWithCorrectOperation() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()
        let mockSpan = MockSpan()
        let mockProvider = MockObservabilityProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 456))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 456))
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        mockProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        _ = try await SpanContext.$_localProvider.withValue(mockProvider) {
            try await useCase.execute(id: 456)
        }

        // Assert
        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.useCaseExecute.value)
        #expect(
            mockSpan.startChildCalledWith[0].description == "FetchTVSeriesDetailsUseCase.execute")
    }

    // MARK: - Test 3: Execute Sets TV Series ID on Span

    @Test func executeSetsTVSeriesIDOnSpan() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()
        let mockSpan = MockSpan()
        let mockProvider = MockObservabilityProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 789))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 789))
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        mockProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        _ = try await SpanContext.$_localProvider.withValue(mockProvider) {
            try await useCase.execute(id: 789)
        }

        // Assert
        #expect(mockSpan.setDataCallCount >= 1)
        let tvSeriesIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "tv_series_id" })
        #expect(tvSeriesIDEntry != nil)
        #expect(tvSeriesIDEntry?.value == "789")
    }

    // MARK: - Test 4: Execute Finishes Span on Success

    @Test func executeFinishesSpanOnSuccess() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()
        let mockSpan = MockSpan()
        let mockProvider = MockObservabilityProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 100))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 100))
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        mockProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        _ = try await SpanContext.$_localProvider.withValue(mockProvider) {
            try await useCase.execute(id: 100)
        }

        // Assert
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    // MARK: - Test 5: Repository Error Throws FetchTVSeriesDetailsError

    @Test func repositoryErrorThrowsFetchTVSeriesDetailsError() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()

        mockRepository.tvSeriesWithIDStub = .failure(.notFound)
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act & Assert
        await #expect(
            performing: {
                try await useCase.execute(id: 200)
            },
            throws: { error in
                error is FetchTVSeriesDetailsError
            })
    }

    // MARK: - Test 6: Repository Error Sets Error on Span and Finishes with InternalError

    @Test func repositoryErrorSetsErrorOnSpanAndFinishesWithInternalError() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()
        let mockSpan = MockSpan()
        let mockProvider = MockObservabilityProvider()

        mockRepository.tvSeriesWithIDStub = .failure(.notFound)
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        mockProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        await #expect(
            performing: {
                try await SpanContext.$_localProvider.withValue(mockProvider) {
                    try await useCase.execute(id: 300)
                }
            }, throws: { _ in true })

        // Assert
        #expect(mockSpan.setDataCallCount >= 2)  // tv_series_id + error
        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    // MARK: - Test 7: AppConfiguration Error Throws FetchTVSeriesDetailsError

    @Test func appConfigurationErrorThrowsFetchTVSeriesDetailsError() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()
        let mockSpan = MockSpan()
        let mockProvider = MockObservabilityProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 400))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 400))
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        mockProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act & Assert
        await #expect(
            performing: {
                try await SpanContext.$_localProvider.withValue(mockProvider) {
                    try await useCase.execute(id: 400)
                }
            },
            throws: { error in
                error is FetchTVSeriesDetailsError
            })
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    // MARK: - Test 8: Works Without Span (Nil SpanContext.provider)

    @Test func worksWithoutSpan() async throws {
        // Arrange
        let mockRepository = MockTVSeriesRepository()
        let mockAppConfigProvider = MockAppConfigurationProvider()

        mockRepository.tvSeriesWithIDStub = .success(Self.mockTVSeries(id: 500))
        mockRepository.imagesForTVSeriesStub = .success(Self.mockImageCollection(id: 500))
        mockAppConfigProvider.appConfigurationStub = .success(Self.mockAppConfiguration())

        SpanContext.provider = nil  // Explicitly nil

        let useCase = DefaultFetchTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Act
        let result = try await useCase.execute(id: 500)

        // Assert
        #expect(result.id == 500)
        #expect(result.name == "Breaking Bad")
    }

    // MARK: - Test Data Builders

    private static func mockTVSeries(id: Int) -> TVSeries {
        TVSeries(
            id: id,
            name: "Breaking Bad",
            overview: "A chemistry teacher turned meth kingpin",
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
    }

    private static func mockImageCollection(id: Int) -> ImageCollection {
        ImageCollection(
            id: id,
            posterPaths: [
                [URL(string: "/poster1.jpg"), URL(string: "/poster2.jpg")].compactMap { $0 }
            ],
            backdropPaths: [
                [URL(string: "/back1.jpg")].compactMap { $0 }
            ],
            logoPaths: [
                [URL(string: "/logo1.jpg")].compactMap { $0 }
            ]
        )
    }

    private static func mockAppConfiguration() -> AppConfiguration {
        let imagesConfig = ImagesConfiguration(
            posterURLHandler: { path, size in
                URL(string: "https://image.tmdb.org/t/p/w\(size)\(path)")
            },
            backdropURLHandler: { path, size in
                URL(string: "https://image.tmdb.org/t/p/w\(size)\(path)")
            },
            logoURLHandler: { path, size in
                URL(string: "https://image.tmdb.org/t/p/w\(size)\(path)")
            },
            profileURLHandler: { path, size in
                URL(string: "https://image.tmdb.org/t/p/w\(size)\(path)")
            }
        )
        return AppConfiguration(images: imagesConfig)
    }

}
