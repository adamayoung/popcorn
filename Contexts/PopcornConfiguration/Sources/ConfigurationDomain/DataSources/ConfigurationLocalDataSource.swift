//
//  ConfigurationLocalDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A data source that provides local storage for application configuration.
///
/// Conforming types must be actors to ensure thread-safe access to cached configuration data.
///
public protocol ConfigurationLocalDataSource: Actor, Sendable {

    /// Retrieves the cached application configuration.
    ///
    /// - Returns: The cached ``AppConfiguration``, or `nil` if no configuration is cached.
    func configuration() async -> AppConfiguration?

    /// Stores the application configuration in the local cache.
    ///
    /// - Parameter appConfiguration: The configuration to cache.
    func setConfiguration(_ appConfiguration: AppConfiguration) async

}
