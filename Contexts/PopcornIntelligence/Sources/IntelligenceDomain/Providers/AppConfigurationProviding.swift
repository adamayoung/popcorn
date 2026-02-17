//
//  AppConfigurationProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

/// Defines the ``AppConfigurationProviding`` contract.
public protocol AppConfigurationProviding: Sendable {

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

/// Represents the ``AppConfigurationProviderError`` values.
public enum AppConfigurationProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
