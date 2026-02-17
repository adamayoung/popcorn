//
//  AppConfigurationProviderAdapterTests.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
import PeopleDomain
@testable import PopcornPeopleAdapters
import Testing

@Suite("AppConfigurationProviderAdapter Tests")
struct AppConfigurationProviderAdapterTests {

    let mockUseCase: MockFetchAppConfigurationUseCase

    init() {
        self.mockUseCase = MockFetchAppConfigurationUseCase()
    }

    @Test("appConfiguration returns configuration when use case succeeds")
    func appConfiguration_returnsConfigurationWhenUseCaseSucceeds() async throws {
        let expectedConfiguration = Self.testConfiguration

        mockUseCase.executeStub = .success(expectedConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        let result = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
        // Verify configuration is returned (comparing by checking same image handler behavior)
        let testPath = try #require(URL(string: "/test.jpg"))
        let expectedPosterURL = expectedConfiguration.images.posterURLSet(for: testPath)
        let resultPosterURL = result.images.posterURLSet(for: testPath)
        #expect(expectedPosterURL?.thumbnail == resultPosterURL?.thumbnail)
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

    @Test("appConfiguration calls use case exactly once")
    func appConfiguration_callsUseCaseExactlyOnce() async throws {
        mockUseCase.executeStub = .success(Self.testConfiguration)

        let adapter = AppConfigurationProviderAdapter(fetchUseCase: mockUseCase)

        _ = try await adapter.appConfiguration()

        #expect(mockUseCase.executeCallCount == 1)
    }

    @Test("appConfiguration throws unknown error when use case throws unknown with nil error")
    func appConfiguration_throwsUnknownErrorWhenUseCaseThrowsUnknownWithNilError() async {
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

}

// MARK: - Test Data

extension AppConfigurationProviderAdapterTests {

    static var testConfiguration: AppConfiguration {
        AppConfiguration(
            images: ImagesConfiguration(
                posterURLHandler: { path, width in
                    guard let path else {
                        return nil
                    }
                    return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path.absoluteString)")
                },
                backdropURLHandler: { path, width in
                    guard let path else {
                        return nil
                    }
                    return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path.absoluteString)")
                },
                logoURLHandler: { path, width in
                    guard let path else {
                        return nil
                    }
                    return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path.absoluteString)")
                },
                profileURLHandler: { path, width in
                    guard let path else {
                        return nil
                    }
                    return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path.absoluteString)")
                }
            )
        )
    }

}

// MARK: - Test Helpers

private struct TestError: Error {}
