//
//  FeatureFlagInitialising.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for initializing feature flag services.
///
/// Implement this protocol to provide startup configuration for feature flag
/// providers.
///
public protocol FeatureFlagInitialising: Sendable {

    ///
    /// Starts the feature flag service with the specified configuration.
    ///
    /// - Parameter config: The configuration containing API key, environment,
    ///   and user identification.
    /// - Throws: An error if the service fails to initialize.
    ///
    func start(_ config: FeatureFlagsConfiguration) async throws

}
