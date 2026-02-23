//
//  DefaultFetchTVEpisodeDetailsUseCaseTests.swift
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

@Suite("DefaultFetchTVEpisodeDetailsUseCaseTests")
struct DefaultFetchTVEpisodeDetailsUseCaseTests {

    let mockRepository: MockTVEpisodeRepository
    let mockAppConfigProvider: MockAppConfigurationProvider
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRepository = MockTVEpisodeRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        self.mockObservabilityProvider = MockObservabilityProvider()

        mockAppConfigProvider.appConfigurationStub = .success(AppConfiguration.mock())
    }

    @Test("execute should return episode summary")
    func execute_shouldReturnEpisodeSummary() async throws {
        let episode = TVEpisode.mock(
            name: "Pilot",
            overview: "Episode overview"
        )
        mockRepository.episodeStub = .success(episode)

        let useCase = makeUseCase()

        let result = try await useCase.execute(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
        )

        #expect(result.name == "Pilot")
        #expect(result.overview == "Episode overview")
        #expect(mockRepository.episodeCallCount == 1)
        #expect(mockAppConfigProvider.appConfigurationCallCount == 1)
    }

    @Test("execute should resolve still URL set")
    func execute_shouldResolveStillURLSet() async throws {
        let episode = TVEpisode.mock(
            stillPath: URL(string: "/still.jpg")
        )
        mockRepository.episodeStub = .success(episode)

        let useCase = makeUseCase()

        let result = try await useCase.execute(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
        )

        #expect(result.stillURLSet != nil)
    }

    @Test("execute should return nil still URL set when path is nil")
    func execute_shouldReturnNilStillURLSetWhenPathIsNil() async throws {
        let episode = TVEpisode.mock(stillPath: nil)
        mockRepository.episodeStub = .success(episode)

        let useCase = makeUseCase()

        let result = try await useCase.execute(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
        )

        #expect(result.stillURLSet == nil)
    }

    @Test("execute should pass correct parameters to repository")
    func execute_shouldPassCorrectParametersToRepository() async throws {
        mockRepository.episodeStub = .success(TVEpisode.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(
            tvSeriesID: 456, seasonNumber: 3, episodeNumber: 5
        )

        let call = try #require(mockRepository.episodeCalledWith.first)
        #expect(call.tvSeriesID == 456)
        #expect(call.seasonNumber == 3)
        #expect(call.episodeNumber == 5)
    }

    @Test("execute should create span with correct operation")
    func execute_shouldCreateSpanWithCorrectOperation() async throws {
        let mockSpan = MockSpan()
        mockRepository.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(
                tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
            )
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.useCaseExecute.value
        )
        #expect(
            mockSpan.startChildCalledWith[0].description
                == "FetchTVEpisodeDetailsUseCase.execute"
        )
    }

    @Test("execute should finish span on success")
    func execute_shouldFinishSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        mockRepository.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute(
                tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
            )
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("execute should throw on repository failure")
    func execute_shouldThrowOnRepositoryFailure() async {
        mockRepository.episodeStub = .failure(.notFound)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(
                    tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
                )
            },
            throws: { error in
                if case .notFound = error as? FetchTVEpisodeDetailsError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute should throw on app configuration failure")
    func execute_shouldThrowOnAppConfigurationFailure() async {
        mockRepository.episodeStub = .success(TVEpisode.mock())
        mockAppConfigProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(
                    tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
                )
            },
            throws: { error in
                error is FetchTVEpisodeDetailsError
            }
        )
    }

    @Test("execute should set error on span on failure")
    func execute_shouldSetErrorOnSpanOnFailure() async {
        let mockSpan = MockSpan()
        mockRepository.episodeStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(
                    mockObservabilityProvider
                ) {
                    try await useCase.execute(
                        tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
                    )
                }
            },
            throws: { _ in true }
        )

        let errorEntry = mockSpan.setDataCalledWith.first { $0.key == "error" }
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute should handle nil overview")
    func execute_shouldHandleNilOverview() async throws {
        mockRepository.episodeStub = .success(TVEpisode.mock(overview: nil))

        let useCase = makeUseCase()

        let result = try await useCase.execute(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
        )

        #expect(result.overview == nil)
    }

}

extension DefaultFetchTVEpisodeDetailsUseCaseTests {

    private func makeUseCase() -> DefaultFetchTVEpisodeDetailsUseCase {
        DefaultFetchTVEpisodeDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )
    }

}
