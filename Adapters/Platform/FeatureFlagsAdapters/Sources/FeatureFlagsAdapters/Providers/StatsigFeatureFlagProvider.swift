//
//  StatsigFeatureFlagProvider.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FeatureFlags
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
                environment: StatsigEnvironment(tier: config.environment.statsigTier)
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

                    Self.logger
                        .info(
                            "Statsig initialised: (user: \(config.userID, privacy: .private), environment: \(config.environment.rawValue, privacy: .public))"
                        )
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
