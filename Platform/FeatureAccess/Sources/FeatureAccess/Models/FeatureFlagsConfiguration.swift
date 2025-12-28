//
//  FeatureFlagsConfiguration.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Configuration settings for initializing a feature flag service.
///
/// Provides the necessary credentials and context for connecting to a feature
/// flag provider.
///
public struct FeatureFlagsConfiguration: Sendable {

    /// The API key for authenticating with the feature flag provider.
    public let apiKey: String

    /// The deployment environment for feature flag evaluation.
    public let environment: Environment

    /// The unique identifier for the current user.
    public let userID: String

    ///
    /// Creates a new feature flags configuration.
    ///
    /// - Parameters:
    ///   - apiKey: The API key for authenticating with the provider.
    ///   - environment: The deployment environment.
    ///   - userID: The unique identifier for the current user.
    ///
    public init(
        apiKey: String,
        environment: Environment,
        userID: String
    ) {
        self.apiKey = apiKey
        self.environment = environment
        self.userID = userID
    }

}

public extension FeatureFlagsConfiguration {

    ///
    /// The deployment environment for feature flag evaluation.
    ///
    /// Different environments may have different feature flag configurations,
    /// allowing features to be tested in development before production rollout.
    ///
    enum Environment: String, Sendable {
        /// Development environment for local testing.
        case development

        /// Staging environment for pre-production testing.
        case staging

        /// Production environment for end users.
        case production
    }

}
