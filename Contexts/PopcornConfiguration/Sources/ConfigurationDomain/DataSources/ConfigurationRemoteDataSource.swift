//
//  ConfigurationRemoteDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A data source that fetches application configuration from a remote service.
///
/// Implement this protocol to provide configuration data from an API or remote backend.
///
public protocol ConfigurationRemoteDataSource: Sendable {

    /// Fetches the application configuration from the remote service.
    ///
    /// - Returns: The fetched ``AppConfiguration``.
    /// - Throws: ``ConfigurationRepositoryError`` if the fetch fails.
    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}
