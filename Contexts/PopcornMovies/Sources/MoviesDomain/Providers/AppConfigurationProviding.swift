//
//  AppConfigurationProviding.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing application configuration.
///
/// This provider supplies application-wide configuration data, including
/// image base URLs and other settings required for proper API integration.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: An ``AppConfiguration`` containing image URLs and other settings.
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

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
