//
//  ConfigurationRepository.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A repository that provides access to application configuration.
///
/// This repository abstracts the data sources and caching logic, providing a clean
/// interface for fetching configuration with configurable cache policies.
///
public protocol ConfigurationRepository: Sendable {

    /// Fetches the application configuration using the specified cache policy.
    ///
    /// - Parameter cachePolicy: The caching strategy to use when fetching.
    /// - Returns: The ``AppConfiguration`` for the application.
    /// - Throws: ``ConfigurationRepositoryError`` if the fetch fails.
    func configuration(
        cachePolicy: CachePolicy
    ) async throws(ConfigurationRepositoryError) -> AppConfiguration

}

public extension ConfigurationRepository {

    /// Fetches the application configuration using the default cache-first policy.
    ///
    /// - Returns: The ``AppConfiguration`` for the application.
    /// - Throws: ``ConfigurationRepositoryError`` if the fetch fails.
    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        try await configuration(cachePolicy: .cacheFirst)
    }

}

///
/// Errors that can occur when fetching configuration from the repository.
///
public enum ConfigurationRepositoryError: Error {

    /// The cache does not contain the requested configuration.
    case cacheUnavailable

    /// The request was not authorised.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
