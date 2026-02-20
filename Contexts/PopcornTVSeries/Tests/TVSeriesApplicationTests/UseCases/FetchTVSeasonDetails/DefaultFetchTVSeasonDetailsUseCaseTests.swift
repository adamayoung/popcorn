//
//  DefaultFetchTVSeasonDetailsUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("DefaultFetchTVSeasonDetailsUseCaseTests")
struct DefaultFetchTVSeasonDetailsUseCaseTests {

    let mockRepository: MockTVSeasonRepository
    let mockAppConfigProvider: MockAppConfigurationProvider
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRepository = MockTVSeasonRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        self.mockObservabilityProvider = MockObservabilityProvider()

        mockAppConfigProvider.appConfigurationStub = .success(AppConfiguration.mock())
    }

    @Test("execute should return season details summary")
    func execute_shouldReturnSeasonDetailsSummary() async throws {
        let season = TVSeason.mock(
            overview: "Season overview",
            episodes: [TVEpisode.mock(id: 1), TVEpisode.mock(id: 2)]
        )
        mockRepository.seasonStub = .success(season)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)

        #expect(result.overview == "Season overview")
        #expect(result.episodes.count == 2)
        #expect(mockRepository.seasonCallCount == 1)
        #expect(mockAppConfigProvider.appConfigurationCallCount == 1)
    }

    @Test("execute should resolve still URL sets")
    func execute_shouldResolveStillURLSets() async throws {
        let season = TVSeason.mock(
            episodes: [TVEpisode.mock(stillPath: URL(string: "/still.jpg"))]
        )
        mockRepository.seasonStub = .success(season)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)

        #expect(result.episodes[0].stillURLSet != nil)
    }

    @Test("execute should return nil still URL set when path is nil")
    func execute_shouldReturnNilStillURLSetWhenPathIsNil() async throws {
        let season = TVSeason.mock(
            episodes: [TVEpisode.mock(stillPath: nil)]
        )
        mockRepository.seasonStub = .success(season)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)

        #expect(result.episodes[0].stillURLSet == nil)
    }

    @Test("execute should pass correct parameters to repository")
    func execute_shouldPassCorrectParametersToRepository() async throws {
        mockRepository.seasonStub = .success(TVSeason.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(tvSeriesID: 456, seasonNumber: 3)

        #expect(mockRepository.seasonCalledWith[0].tvSeriesID == 456)
        #expect(mockRepository.seasonCalledWith[0].seasonNumber == 3)
    }

    @Test("execute should create span with correct operation")
    func execute_shouldCreateSpanWithCorrectOperation() async throws {
        let mockSpan = MockSpan()
        mockRepository.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.useCaseExecute.value
        )
        #expect(
            mockSpan.startChildCalledWith[0].description
                == "FetchTVSeasonDetailsUseCase.execute"
        )
    }

    @Test("execute should finish span on success")
    func execute_shouldFinishSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        mockRepository.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("execute should throw on repository failure")
    func execute_shouldThrowOnRepositoryFailure() async {
        mockRepository.seasonStub = .failure(.notFound)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)
            },
            throws: { error in
                if case .notFound = error as? FetchTVSeasonDetailsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute should throw on app configuration failure")
    func execute_shouldThrowOnAppConfigurationFailure() async {
        mockRepository.seasonStub = .success(TVSeason.mock())
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)
            },
            throws: { error in
                error is FetchTVSeasonDetailsError
            }
        )
    }

    @Test("execute should set error on span on failure")
    func execute_shouldSetErrorOnSpanOnFailure() async {
        let mockSpan = MockSpan()
        mockRepository.seasonStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(
                    mockObservabilityProvider
                ) {
                    try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)
                }
            },
            throws: { _ in true }
        )

        let errorEntry = mockSpan.setDataCalledWith.first { $0.key == "error" }
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should handle empty episodes")
    func execute_shouldHandleEmptyEpisodes() async throws {
        let season = TVSeason.mock(overview: "Overview only", episodes: [])
        mockRepository.seasonStub = .success(season)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)

        #expect(result.overview == "Overview only")
        #expect(result.episodes.isEmpty)
    }

    @Test("execute should handle nil overview")
    func execute_shouldHandleNilOverview() async throws {
        let season = TVSeason.mock(overview: nil)
        mockRepository.seasonStub = .success(season)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 1396, seasonNumber: 1)

        #expect(result.overview == nil)
    }

}

extension DefaultFetchTVSeasonDetailsUseCaseTests {

    private func makeUseCase() -> DefaultFetchTVSeasonDetailsUseCase {
        DefaultFetchTVSeasonDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )
    }

}
