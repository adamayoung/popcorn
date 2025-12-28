//
//  AppConfigurationProviding.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing application configuration.
///
/// Implementations of this protocol are responsible for fetching the
/// application's configuration, including image URL configurations
/// needed to build complete image URLs for TV series media.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Fetches the current application configuration.
    ///
    /// - Returns: An ``AppConfiguration`` containing image URL settings and other configuration.
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be retrieved.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when fetching application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
