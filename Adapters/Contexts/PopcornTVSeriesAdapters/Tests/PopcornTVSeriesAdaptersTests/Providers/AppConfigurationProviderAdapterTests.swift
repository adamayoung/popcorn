//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain

@testable import PopcornTVSeriesAdapters

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    let mockUseCase: MockFetchAppConfigurationUseCase

    init() {
        self.mockUseCase = MockFetchAppConfigurationUseCase()
    }

    @Test("appConfiguration returns configuration from use case")
    func appConfiguration_returnsConfigurationFromUseCase() async throws {
        let path = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let imagesConfiguration = ImagesConfiguration.mock()
        let appConfiguration = AppConfiguration.mock(images: imagesConfiguration)

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        let expected = try #require(imagesConfiguration.posterURLSet(for: path))

        #expect(mockUseCase.executeCallCount == 1)
        #expect(try #require(result.images.posterURLSet(for: path)) == expected)
    }

    @Test("appConfiguration throws unauthorised error from use case")
    func appConfiguration_throwsUnauthorisedErrorFromUseCase() async {
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

    @Test("appConfiguration sets span error and finishes with internal error on failure")
    func appConfiguration_setsSpanErrorAndFinishesWithInternalErrorOnFailure() async {
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

}

private extension AppConfigurationProviderAdapterTests {

    struct TestError: Error {}

}
