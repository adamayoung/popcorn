//
//  FeatureFlagging.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for checking feature flag states.
///
/// Use this protocol to query whether specific features are enabled for the
/// current user and environment.
///
public protocol FeatureFlagging: Sendable {

    /// A Boolean value indicating whether the feature flag service has been initialized.
    var isInitialised: Bool { get }

    ///
    /// Checks whether a feature flag is enabled.
    ///
    /// - Parameter flag: The feature flag to check.
    /// - Returns: `true` if the feature is enabled, `false` otherwise.
    ///
    func isEnabled(_ flag: FeatureFlag) -> Bool

    ///
    /// Checks whether a feature flag is enabled using a string key.
    ///
    /// - Parameter key: The string key identifying the feature flag.
    /// - Returns: `true` if the feature is enabled, `false` otherwise.
    ///
    func isEnabled(_ key: some StringProtocol) -> Bool

}
