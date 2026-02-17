//
//  StatsigFeatureFlagProvider.swift
//  FeatureAccessAdapters
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import Foundation
import OSLog
import Statsig

struct StatsigFeatureFlagProvider: FeatureFlagProviding {

    private static let logger = Logger.featureFlags

    var isInitialized: Bool {
        Statsig.isInitialized()
    }

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
