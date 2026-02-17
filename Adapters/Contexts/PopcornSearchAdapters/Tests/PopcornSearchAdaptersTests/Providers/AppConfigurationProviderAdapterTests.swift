//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import Testing

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    let mockUseCase: MockFetchAppConfigurationUseCase

    init() {
        self.mockUseCase = MockFetchAppConfigurationUseCase()
    }

    @Test("appConfiguration returns configuration from use case")
    func appConfigurationReturnsConfigurationFromUseCase() async throws {
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

    @Test("appConfiguration throws unknown error from use case for unknown error")
    func appConfigurationThrowsUnknownErrorFromUseCaseForUnknownError() async {
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

    @Test("appConfiguration calls use case exactly once")
    func appConfigurationCallsUseCaseExactlyOnce() async throws {
        let appConfiguration = AppConfiguration.mock()

        mockUseCase.executeStub = .success(appConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
    }

}

private extension AppConfigurationProviderAdapterTests {

    struct TestError: Error {}

}
