//
//  TMDbConfigurationRemoteDataSource.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import CoreDomain
import Foundation
import TMDb

///
/// A remote data source that fetches application configuration from TMDb API.
///
/// This data source adapts the TMDb configuration service to the domain's
/// ``ConfigurationRemoteDataSource`` protocol, translating TMDb API responses
/// into domain entities.
///
final class TMDbConfigurationRemoteDataSource: ConfigurationRemoteDataSource {

    private let configurationService: any ConfigurationService

    ///
    /// Creates a new TMDb configuration remote data source.
    ///
    /// - Parameter configurationService: The TMDb configuration service for fetching API configuration.
    ///
    init(configurationService: any ConfigurationService) {
        self.configurationService = configurationService
    }

    ///
    /// Fetches the application configuration from the TMDb API.
    ///
    /// - Returns: The application configuration containing image URL handlers and other settings.
    ///
    /// - Throws: ``ConfigurationRepositoryError`` if the fetch operation fails.
    ///
    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        let tmdbAPIConfiguration: TMDb.APIConfiguration

        do {
            tmdbAPIConfiguration = try await configurationService.apiConfiguration()
        } catch let error {
            throw ConfigurationRepositoryError(error)
        }

        let mapper = AppConfigurationMapper()
        return mapper.map(tmdbAPIConfiguration)
    }

}

private extension ConfigurationRepositoryError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
