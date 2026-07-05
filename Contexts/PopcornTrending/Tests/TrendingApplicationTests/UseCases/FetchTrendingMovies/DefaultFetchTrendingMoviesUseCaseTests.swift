//
//  DefaultFetchTrendingMoviesUseCaseTests.swift
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

@Suite("DefaultFetchTrendingMoviesUseCase")
struct DefaultFetchTrendingMoviesUseCaseTests {

    let mockRepository: MockTrendingRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockLogoImageProvider: MockMovieLogoImageProvider

    init() {
        self.mockRepository = MockTrendingRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockLogoImageProvider = MockMovieLogoImageProvider()
    }

    @Test("execute returns movie preview details on success")
    func executeReturnsMoviePreviewDetailsOnSuccess() async throws {
        let moviePreviews = MoviePreview.mocks
        mockRepository.moviesStub = .success(moviePreviews)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == moviePreviews.count)
        #expect(result[0].id == moviePreviews[0].id)
    }

    @Test("execute calls execute(page:) with page 1")
    func executeCallsExecutePageWithPageOne() async throws {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockRepository.moviesCalledWith == [1])
    }

    @Test("execute with page passes page to repository")
    func executeWithPagePassesPageToRepository() async throws {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(page: 5)

        #expect(mockRepository.moviesCalledWith == [5])
    }

    @Test("execute calls app configuration provider once")
    func executeCallsAppConfigurationProviderOnce() async throws {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute with no results returns empty array")
    func executeWithNoResultsReturnsEmptyArray() async throws {
        mockRepository.moviesStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.isEmpty)
    }

    @Test("execute does not call the logo image provider")
    func executeDoesNotCallLogoImageProvider() async throws {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockLogoImageProvider.imageURLSetCallCount == 0)
    }

    @Test("execute extracts theme color using theme color provider when poster path is present")
    func executeExtractsThemeColorWhenPosterPathPresent() async throws {
        let moviePreview = MoviePreview.mock(id: 1, posterPath: URL(string: "/poster.jpg"))
        let themeColor = ThemeColor.mock()
        let mockThemeColorProvider = MockThemeColorProvider(themeColorResult: themeColor)
        mockRepository.moviesStub = .success([moviePreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase(themeColorProvider: mockThemeColorProvider)

        let result = try await useCase.execute()

        #expect(result[0].themeColor == themeColor)
        #expect(mockThemeColorProvider.themeColorCallCount == 1)
    }

    @Test("execute returns nil theme color when theme color provider is nil")
    func executeReturnsNilThemeColorWhenProviderIsNil() async throws {
        let moviePreview = MoviePreview.mock(posterPath: URL(string: "/poster.jpg"))
        mockRepository.moviesStub = .success([moviePreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result[0].themeColor == nil)
    }

    @Test("execute skips theme color extraction when poster path is nil")
    func executeSkipsThemeColorExtractionWhenPosterPathIsNil() async throws {
        let moviePreview = MoviePreview.mock(posterPath: nil)
        let mockThemeColorProvider = MockThemeColorProvider(themeColorResult: .mock())
        mockRepository.moviesStub = .success([moviePreview])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase(themeColorProvider: mockThemeColorProvider)

        let result = try await useCase.execute()

        #expect(result[0].themeColor == nil)
        #expect(mockThemeColorProvider.themeColorCallCount == 0)
    }

    // MARK: - Helpers

    private func makeUseCase(
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) -> DefaultFetchTrendingMoviesUseCase {
        DefaultFetchTrendingMoviesUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider,
            logoImageProvider: mockLogoImageProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
