//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
@testable import PopcornTVSeriesAdapters
import Testing
import TVSeriesDomain

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    let mockUseCase: MockFetchAppConfigurationUseCase

    init() {
        self.mockUseCase = MockFetchAppConfigurationUseCase()
    }

    // MARK: - Success Cases

    @Test("appConfiguration returns configuration from use case")
    func appConfigurationReturnsConfigurationFromUseCase() async throws {
        let path = try #require(URL(string: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg"))
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
        let appConfiguration = AppConfiguration.mock()

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
    }

    @Test("appConfiguration returns same configuration images from use case")
    func appConfigurationReturnsSameConfigurationImagesFromUseCase() async throws {
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
        let path = try #require(URL(string: "/breaking_bad_poster.jpg"))
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
        let path = try #require(URL(string: "/breaking_bad_backdrop.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let backdropURLSet = result.images.backdropURLSet(for: path)
        #expect(backdropURLSet != nil)
    }

    @Test("appConfiguration returns images configuration with correct logo URL set")
    func appConfigurationReturnsImagesConfigurationWithCorrectLogoURLSet() async throws {
        let path = try #require(URL(string: "/breaking_bad_logo.png"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let logoURLSet = result.images.logoURLSet(for: path)
        #expect(logoURLSet != nil)
    }

    // MARK: - Error Cases

    @Test("appConfiguration throws unauthorised error from use case")
    func appConfigurationThrowsUnauthorisedErrorFromUseCase() async {
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

    @Test("appConfiguration throws unknown error for unknown use case error")
    func appConfigurationThrowsUnknownErrorForUnknownUseCaseError() async {
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

    @Test("appConfiguration throws unknown error for unknown use case error with nil")
    func appConfigurationThrowsUnknownErrorForUnknownUseCaseErrorWithNil() async {
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

    // MARK: - Observability Tests

    @Test("appConfiguration sets span error and finishes with internal error on failure")
    func appConfigurationSetsSpanErrorAndFinishesWithInternalErrorOnFailure() async {
        let mockSpan = MockSpan()
        let mockObservabilityProvider = MockObservabilityProvider()

        mockUseCase.executeStub = .failure(.unknown(TestError()))
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await adapter.appConfiguration()
                }
            },
            throws: { _ in true }
        )

        #expect(mockSpan.setDataCallCount > 0)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("appConfiguration sets span error for unauthorised error")
    func appConfigurationSetsSpanErrorForUnauthorisedError() async {
        let mockSpan = MockSpan()
        let mockObservabilityProvider = MockObservabilityProvider()

        mockUseCase.executeStub = .failure(.unauthorised)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await adapter.appConfiguration()
                }
            },
            throws: { _ in true }
        )

        #expect(mockSpan.setDataCallCount > 0)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("appConfiguration finishes span on success")
    func appConfigurationFinishesSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        let mockObservabilityProvider = MockObservabilityProvider()
        let appConfiguration = AppConfiguration.mock()

        mockUseCase.executeStub = .success(appConfiguration)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await adapter.appConfiguration()
        }

        #expect(mockSpan.finishCallCount == 1)
    }

    // MARK: - Multiple Calls Tests

    @Test("appConfiguration can be called multiple times")
    func appConfigurationCanBeCalledMultipleTimes() async throws {
        let appConfiguration = AppConfiguration.mock()

        mockUseCase.executeStub = .success(appConfiguration)

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
