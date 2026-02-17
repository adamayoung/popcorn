//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import PlotRemixGameDomain
@testable import PopcornPlotRemixGameAdapters
import Testing

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    // MARK: - Success Cases

    @Test("appConfiguration returns configuration from use case")
    func appConfigurationReturnsConfigurationFromUseCase() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()
        let path = try #require(URL(string: "/poster.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let expected = try #require(imagesConfiguration.posterURLSet(for: path))

        #expect(mockUseCase.executeCallCount == 1)
        #expect(try #require(result.images.posterURLSet(for: path)) == expected)
    }

    @Test("appConfiguration calls use case exactly once")
    func appConfigurationCallsUseCaseExactlyOnce() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()
        let appConfiguration = AppConfiguration.mock()

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
    }

    @Test("appConfiguration returns same configuration images from use case")
    func appConfigurationReturnsSameConfigurationImagesFromUseCase() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()
        let path = try #require(URL(string: "/test/poster.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let expectedPosterURLSet = imagesConfiguration.posterURLSet(for: path)
        let resultPosterURLSet = result.images.posterURLSet(for: path)

        #expect(resultPosterURLSet == expectedPosterURLSet)
    }

    @Test("appConfiguration returns images configuration with correct poster URL set")
    func appConfigurationReturnsImagesConfigurationWithCorrectPosterURLSet() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()
        let path = try #require(URL(string: "/movie_poster.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let posterURLSet = result.images.posterURLSet(for: path)
        #expect(posterURLSet != nil)
    }

    @Test("appConfiguration returns images configuration with correct backdrop URL set")
    func appConfigurationReturnsImagesConfigurationWithCorrectBackdropURLSet() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()
        let path = try #require(URL(string: "/movie_backdrop.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let backdropURLSet = result.images.backdropURLSet(for: path)
        #expect(backdropURLSet != nil)
    }

    // MARK: - Error Cases

    @Test("appConfiguration throws unauthorised error")
    func appConfigurationThrowsUnauthorisedError() async {
        let mockUseCase = MockFetchAppConfigurationUseCase()

        mockUseCase.executeStub = .failure(.unauthorised)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.appConfiguration()
            },
            throws: { error in
                guard let error = error as? AppConfigurationProviderError else {
                    return false
                }
                if case .unauthorised = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("appConfiguration throws unknown error")
    func appConfigurationThrowsUnknownError() async {
        let mockUseCase = MockFetchAppConfigurationUseCase()

        mockUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.appConfiguration()
            },
            throws: { error in
                guard let error = error as? AppConfigurationProviderError else {
                    return false
                }
                if case .unknown = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("appConfiguration throws unknown error for generic error")
    func appConfigurationThrowsUnknownErrorForGenericError() async {
        let mockUseCase = MockFetchAppConfigurationUseCase()

        mockUseCase.executeStub = .failure(.unknown())

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.appConfiguration()
            },
            throws: { error in
                guard let error = error as? AppConfigurationProviderError else {
                    return false
                }
                if case .unknown = error {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Multiple Calls Tests

    @Test("appConfiguration calls use case exactly once per call")
    func appConfigurationCallsUseCaseExactlyOncePerCall() async throws {
        let mockUseCase = MockFetchAppConfigurationUseCase()

        mockUseCase.executeStub = .success(AppConfiguration.mock())

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()
        _ = try await adapter.appConfiguration()
        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 3)
    }

}

// MARK: - Test Helpers

private extension AppConfigurationProviderAdapterTests {

    struct TestError: Error {}

}
