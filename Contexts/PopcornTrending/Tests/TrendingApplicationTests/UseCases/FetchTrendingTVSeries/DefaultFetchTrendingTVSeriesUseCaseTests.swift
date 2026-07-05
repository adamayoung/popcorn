//
//  DefaultFetchTrendingTVSeriesUseCaseTests.swift
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

@Suite("DefaultFetchTrendingTVSeriesUseCase")
struct DefaultFetchTrendingTVSeriesUseCaseTests {

    let mockRepository: MockTrendingRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockTrendingRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    @Test("execute returns tv series preview details on success")
    func executeReturnsTVSeriesPreviewDetailsOnSuccess() async throws {
        let tvSeriesPreviews = TVSeriesPreview.mocks
        mockRepository.tvSeriesStub = .success(tvSeriesPreviews)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == tvSeriesPreviews.count)
        #expect(result[0].id == tvSeriesPreviews[0].id)
    }

    @Test("execute calls execute(page:) with page 1")
    func executeCallsExecutePageWithPageOne() async throws {
        mockRepository.tvSeriesStub = .success(TVSeriesPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockRepository.tvSeriesCalledWith == [1])
    }

    @Test("execute with page passes page to repository")
    func executeWithPagePassesPageToRepository() async throws {
        mockRepository.tvSeriesStub = .success(TVSeriesPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(page: 5)

        #expect(mockRepository.tvSeriesCalledWith == [5])
    }

    @Test("execute calls app configuration provider once")
    func executeCallsAppConfigurationProviderOnce() async throws {
        mockRepository.tvSeriesStub = .success(TVSeriesPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute with no results returns empty array")
    func executeWithNoResultsReturnsEmptyArray() async throws {
        mockRepository.tvSeriesStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.isEmpty)
    }

    @Test("execute extracts theme color using theme color provider when poster path is present")
    func executeExtractsThemeColorWhenPosterPathPresent() async throws {
        let tvSeriesPreview = TVSeriesPreview.mock(id: 1, posterPath: URL(string: "/poster.jpg"))
        let themeColor = ThemeColor.mock()
        let mockThemeColorProvider = MockThemeColorProvider(themeColorResult: themeColor)
        mockRepository.tvSeriesStub = .success([tvSeriesPreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase(themeColorProvider: mockThemeColorProvider)

        let result = try await useCase.execute()

        #expect(result[0].themeColor == themeColor)
        #expect(mockThemeColorProvider.themeColorCallCount == 1)
    }

    @Test("execute returns nil theme color when theme color provider is nil")
    func executeReturnsNilThemeColorWhenProviderIsNil() async throws {
        let tvSeriesPreview = TVSeriesPreview.mock(posterPath: URL(string: "/poster.jpg"))
        mockRepository.tvSeriesStub = .success([tvSeriesPreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result[0].themeColor == nil)
    }

    @Test("execute skips theme color extraction when poster path is nil")
    func executeSkipsThemeColorExtractionWhenPosterPathIsNil() async throws {
        let tvSeriesPreview = TVSeriesPreview.mock(posterPath: nil)
        let mockThemeColorProvider = MockThemeColorProvider(themeColorResult: .mock())
        mockRepository.tvSeriesStub = .success([tvSeriesPreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase(themeColorProvider: mockThemeColorProvider)

        let result = try await useCase.execute()

        #expect(result[0].themeColor == nil)
        #expect(mockThemeColorProvider.themeColorCallCount == 0)
    }

    // MARK: - Helpers

    private func makeUseCase(
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) -> DefaultFetchTrendingTVSeriesUseCase {
        DefaultFetchTrendingTVSeriesUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
