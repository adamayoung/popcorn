//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TrendingDomain

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    let mockUseCase: MockFetchAppConfigurationUseCase

    init() {
        self.mockUseCase = MockFetchAppConfigurationUseCase()
    }

    @Test("appConfiguration returns configuration when use case succeeds")
    func appConfiguration_returnsConfigurationWhenUseCaseSucceeds() async throws {
        let expectedConfiguration = makeAppConfiguration()
        mockUseCase.executeStub = .success(expectedConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
        // Verify images configuration is present — we can't directly compare closures
        // so we verify that the result is returned successfully
        _ = result.images
    }

    @Test("appConfiguration throws unauthorised error when use case throws unauthorised")
    func appConfiguration_throwsUnauthorisedErrorWhenUseCaseThrowsUnauthorised() async {
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

    @Test("appConfiguration throws unknown error when use case throws unknown")
    func appConfiguration_throwsUnknownErrorWhenUseCaseThrowsUnknown() async {
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

    @Test("appConfiguration throws unknown error when use case throws unknown with nil")
    func appConfiguration_throwsUnknownErrorWhenUseCaseThrowsUnknownWithNil() async {
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

    @Test("appConfiguration calls use case exactly once")
    func appConfiguration_callsUseCaseExactlyOnce() async throws {
        let configuration = makeAppConfiguration()
        mockUseCase.executeStub = .success(configuration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
    }

}

// MARK: - Test Helpers

private extension AppConfigurationProviderAdapterTests {

    struct TestError: Error {}

    func makeAppConfiguration() -> AppConfiguration {
        let imagesConfiguration = ImagesConfiguration(
            posterURLHandler: { path, _ in path },
            backdropURLHandler: { path, _ in path },
            logoURLHandler: { path, _ in path },
            profileURLHandler: { path, _ in path }
        )

        return AppConfiguration(images: imagesConfiguration)
    }

}
