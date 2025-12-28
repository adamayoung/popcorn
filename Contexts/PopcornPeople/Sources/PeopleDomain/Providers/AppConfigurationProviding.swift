//
//  AppConfigurationProviding.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Defines the contract for providing application configuration.
///
/// Implementations of this protocol supply configuration data required by the
/// people context, such as image URL configurations for profile pictures.
///
public protocol AppConfigurationProviding: Sendable {

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: The ``AppConfiguration`` containing settings like image URLs.
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
