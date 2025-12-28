//
//  AppConfigurationProviding.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for application configuration data.
///
/// Implementations of this protocol supply configuration settings required
/// for the trending module, such as image URL configurations.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: The application configuration containing settings like image URLs.
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be retrieved.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when retrieving application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
