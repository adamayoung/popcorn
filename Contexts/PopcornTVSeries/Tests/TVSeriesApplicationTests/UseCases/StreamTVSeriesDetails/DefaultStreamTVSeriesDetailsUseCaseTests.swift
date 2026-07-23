//
//  DefaultStreamTVSeriesDetailsUseCaseTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("DefaultStreamTVSeriesDetailsUseCaseTests")
struct DefaultStreamTVSeriesDetailsUseCaseTests {

    let mockRepository: MockTVSeriesRepository
    let mockAppConfigProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockTVSeriesRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        mockAppConfigProvider.appConfigurationStub = .success(AppConfiguration.mock())
    }

    @Test("stream emits TV series details with the provider's theme colour")
    func stream_emitsDetailsWithThemeColor() async throws {
        let id = 1396
        let tvSeries = TVSeries.mock(id: id, posterPath: URL(string: "/poster.jpg"))
        mockRepository.tvSeriesStreamValues = [tvSeries]
        mockRepository.imagesForTVSeriesStub = .success(ImageCollection.mock(id: id))
        let themeColor = ThemeColor.mock()
        let themeColorProvider = MockThemeColorProvider(themeColorResult: themeColor)

        let useCase = DefaultStreamTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider,
            themeColorProvider: themeColorProvider
        )

        let results = try await collect(useCase.stream(id: id))

        #expect(results.count == 1)
        let details = try #require(results.first ?? nil)
        #expect(details.id == id)
        #expect(details.themeColor == themeColor)
        #expect(themeColorProvider.themeColorCallCount == 1)
    }

    @Test("stream coalesces identical consecutive emissions")
    func stream_coalescesIdenticalEmissions() async throws {
        let id = 1396
        let tvSeries = TVSeries.mock(id: id, posterPath: URL(string: "/poster.jpg"))
        mockRepository.tvSeriesStreamValues = [tvSeries, tvSeries]
        mockRepository.imagesForTVSeriesStub = .success(ImageCollection.mock(id: id))
        let themeColorProvider = MockThemeColorProvider(themeColorResult: ThemeColor.mock())

        let useCase = DefaultStreamTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider,
            themeColorProvider: themeColorProvider
        )

        let results = try await collect(useCase.stream(id: id))

        #expect(results.count == 1)
    }

    @Test("stream yields nil when the domain series is nil")
    func stream_yieldsNilForNilSeries() async throws {
        let id = 1396
        mockRepository.tvSeriesStreamValues = [nil]

        let useCase = DefaultStreamTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        let results = try await collect(useCase.stream(id: id))

        #expect(results.count == 1)
        #expect(results.first ?? nil == nil)
    }

    @Test("stream skips a tick whose build fails and keeps the stream alive")
    func stream_skipsFailedTickAndStaysAlive() async throws {
        let id = 1396
        let tvSeries = TVSeries.mock(id: id, posterPath: URL(string: "/poster.jpg"))
        mockRepository.tvSeriesStreamValues = [tvSeries, tvSeries]
        mockRepository.imagesForTVSeriesStub = .failure(.notFound)

        let useCase = DefaultStreamTVSeriesDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigProvider
        )

        // Must complete without throwing — failed ticks are skipped, not fatal.
        let results = try await collect(useCase.stream(id: id))

        #expect(results.isEmpty)
        // Both ticks were attempted, proving the stream stayed alive after the first failure.
        #expect(mockRepository.imagesForTVSeriesCallCount == 2)
    }

    // MARK: - Helpers

    private func collect(
        _ stream: AsyncThrowingStream<TVSeriesDetails?, Error>
    ) async throws -> [TVSeriesDetails?] {
        var results: [TVSeriesDetails?] = []
        for try await value in stream {
            results.append(value)
        }
        return results
    }

}
