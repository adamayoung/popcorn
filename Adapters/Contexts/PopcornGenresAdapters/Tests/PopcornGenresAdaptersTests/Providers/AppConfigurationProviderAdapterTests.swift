//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import GenresDomain
@testable import PopcornGenresAdapters
import Testing

@Suite("AppConfigurationProviderAdapter")
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

    @Test("appConfiguration throws unauthorised error")
    func appConfigurationThrowsUnauthorisedError() async {
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
        mockUseCase.executeStub = .failure(.unknown(nil))

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

}
