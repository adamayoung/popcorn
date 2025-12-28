//
//  StatsigFeatureFlagProvider.swift
//  FeatureAccessAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation
import OSLog
import Statsig

///
/// A feature flag provider that uses Statsig for feature flag management.
///
/// This provider implements ``FeatureFlagProviding`` by wrapping the Statsig SDK
/// to enable and check feature flags.
///
struct StatsigFeatureFlagProvider: FeatureFlagProviding {

    private static let logger = Logger.featureFlags

    ///
    /// Indicates whether Statsig has been initialized.
    ///
    var isInitialized: Bool {
        Statsig.isInitialized()
    }

    ///
    /// Initializes the Statsig SDK with the provided configuration.
    ///
    /// - Parameter config: The feature flags configuration containing API key and environment settings.
    ///
    /// - Throws: An error if Statsig initialization fails.
    ///
    func start(_ config: FeatureFlagsConfiguration) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let options = StatsigOptions(
                environment: StatsigEnvironment(tier: config.environment.statsigTier),
                enableAutoValueUpdate: true
            )

            Statsig.initialize(
                sdkKey: config.apiKey,
                user: StatsigUser(userID: config.userID),
                options: options,
                completion: { error in
                    if let error {
                        Self.logger.error(
                            "Statsig failed to initialise: \(error.localizedDescription, privacy: .public)"
                        )
                        continuation.resume(throwing: error)
                        return
                    }

                    if Statsig.isInitialized() {
                        Self.logger
                            .info(
                                "Statsig enabled (user: \(config.userID, privacy: .private), environment: \(config.environment.rawValue, privacy: .public))"
                            )
                    } else {
                        Self.logger
                            .warning(
                                "Statsig disabled"
                            )
                    }

                    continuation.resume()
                }
            )
        }
    }

    ///
    /// Checks whether a feature flag is enabled.
    ///
    /// - Parameter key: The key identifying the feature flag to check.
    ///
    /// - Returns: `true` if the feature flag is enabled, `false` otherwise.
    ///
    func isEnabled(_ key: String) -> Bool {
        Statsig.checkGate(key)
    }
}

private extension FeatureFlagsConfiguration.Environment {

    var statsigTier: StatsigEnvironment.EnvironmentTier {
        switch self {
        case .development: .Development
        case .staging: .Staging
        case .production: .Production
        }
    }

}
