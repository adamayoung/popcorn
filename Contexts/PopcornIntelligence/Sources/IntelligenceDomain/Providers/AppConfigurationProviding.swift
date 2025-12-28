//
//  AppConfigurationProviding.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A protocol for providing application configuration settings.
///
/// Conforming types supply the application with its runtime configuration,
/// which may include API keys, feature flags, and other environment-specific settings.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: The current ``AppConfiguration`` instance.
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be retrieved.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when retrieving application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorised to access the configuration.
    case unauthorised

    /// An unknown error occurred while retrieving the configuration.
    case unknown(Error? = nil)

}
