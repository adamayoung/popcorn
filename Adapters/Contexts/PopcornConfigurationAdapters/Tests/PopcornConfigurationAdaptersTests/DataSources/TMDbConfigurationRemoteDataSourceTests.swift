//
//  TMDbConfigurationRemoteDataSourceTests.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import Foundation
@testable import PopcornConfigurationAdapters
import Testing
import TMDb

@Suite("TMDbConfigurationRemoteDataSource Tests")
struct TMDbConfigurationRemoteDataSourceTests {

    let mockService: MockConfigurationService

    init() {
        self.mockService = MockConfigurationService()
    }

    @Test("configuration returns mapped AppConfiguration on success")
    func configurationReturnsMappedAppConfigurationOnSuccess() async throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
        let tmdbAPIConfiguration = TMDb.APIConfiguration(
            images: tmdbImagesConfiguration,
            changeKeys: ["adult", "air_date", "title"]
        )

        mockService.apiConfigurationStub = .success(tmdbAPIConfiguration)

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        let result = try await dataSource.configuration()

        #expect(result.images != nil)
        #expect(mockService.apiConfigurationCallCount == 1)
    }

    @Test("configuration throws unauthorised error for TMDb unauthorised")
    func configurationThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.apiConfigurationStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb network error")
    func configurationThrowsUnknownErrorForTMDbNetworkError() async {
        mockService.apiConfigurationStub = .failure(.network(TestError()))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb serverError")
    func configurationThrowsUnknownErrorForTMDbServerError() async {
        mockService.apiConfigurationStub = .failure(.serverError("Server unavailable"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb badRequest")
    func configurationThrowsUnknownErrorForTMDbBadRequest() async {
        mockService.apiConfigurationStub = .failure(.badRequest("Invalid request"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb forbidden")
    func configurationThrowsUnknownErrorForTMDbForbidden() async {
        mockService.apiConfigurationStub = .failure(.forbidden("Access denied"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb notFound")
    func configurationThrowsUnknownErrorForTMDbNotFound() async {
        mockService.apiConfigurationStub = .failure(.notFound("Not found"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb tooManyRequests")
    func configurationThrowsUnknownErrorForTMDbTooManyRequests() async {
        mockService.apiConfigurationStub = .failure(.tooManyRequests("Rate limited"))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb decode error")
    func configurationThrowsUnknownErrorForTMDbDecodeError() async {
        mockService.apiConfigurationStub = .failure(.decode(TestError()))

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("configuration throws unknown error for TMDb unknown error")
    func configurationThrowsUnknownErrorForTMDbUnknownError() async {
        mockService.apiConfigurationStub = .failure(.unknown)

        let dataSource = TMDbConfigurationRemoteDataSource(configurationService: mockService)

        await #expect(
            performing: {
                try await dataSource.configuration()
            },
            throws: { error in
                guard let error = error as? ConfigurationRepositoryError else {
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

// MARK: - Test Helpers

private extension TMDbConfigurationRemoteDataSourceTests {

    struct TestError: Error {}

}
