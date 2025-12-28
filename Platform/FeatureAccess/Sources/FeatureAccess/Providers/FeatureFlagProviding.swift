//
//  FeatureFlagProviding.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for implementing feature flag providers.
///
/// Implement this protocol to integrate with external feature flag services
/// such as LaunchDarkly, Firebase Remote Config, or custom solutions.
///
public protocol FeatureFlagProviding: Sendable {

    /// A Boolean value indicating whether the provider has been initialized.
    var isInitialized: Bool { get }

    ///
    /// Starts the feature flag provider with the specified configuration.
    ///
    /// - Parameter config: The configuration containing credentials and context.
    /// - Throws: An error if the provider fails to initialize.
    ///
    func start(_ config: FeatureFlagsConfiguration) async throws

    ///
    /// Checks whether a feature flag is enabled.
    ///
    /// - Parameter key: The string key identifying the feature flag.
    /// - Returns: `true` if the feature is enabled, `false` otherwise.
    ///
    func isEnabled(_ key: String) -> Bool

}
