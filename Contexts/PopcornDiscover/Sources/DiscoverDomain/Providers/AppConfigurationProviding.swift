//
//  AppConfigurationProviding.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing application configuration.
///
/// Implementations of this protocol fetch configuration data such as
/// image base URLs and size options from the remote API.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Fetches the current application configuration.
    ///
    /// - Returns: An ``AppConfiguration`` instance containing image URLs and other settings.
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be fetched.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

///
/// Errors that can occur when fetching application configuration.
///
public enum AppConfigurationProviderError: Error {

    /// The request was not authorized due to invalid or missing credentials.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
