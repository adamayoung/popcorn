//
//  AppConfigurationProviding.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A provider for retrieving application configuration settings.
///
/// Implementations of this protocol fetch configuration data required by the search module,
/// such as image URL configurations for constructing media asset URLs.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Fetches the current application configuration.
    ///
    /// - Returns: The application configuration containing settings like image URL bases.
    /// - Throws: ``AppConfigurationProviderError`` if the fetch operation fails.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when fetching application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorized, typically due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred.
    case unknown(Error? = nil)

}
