//
//  AppConfigurationProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A protocol for retrieving application configuration settings.
///
/// Implementations provide access to app-wide configuration such as API keys,
/// feature flags, and other runtime settings needed by the Plot Remix game context.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: The application configuration containing API settings and feature flags.
    /// - Throws: ``AppConfigurationProviderError`` if configuration retrieval fails.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when retrieving application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorized to access configuration.
    case unauthorised

    /// An unknown error occurred during configuration retrieval.
    case unknown(Error? = nil)

}
