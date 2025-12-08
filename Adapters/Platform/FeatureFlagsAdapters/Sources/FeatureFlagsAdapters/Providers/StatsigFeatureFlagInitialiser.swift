//
//  StatsigFeatureFlagInitialiser.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import FeatureFlags
import Foundation
import OSLog
import Statsig

public struct StatsigFeatureFlagInitialiser {

    private static let logger = Logger(
        subsystem: "FeatureFlagsAdapters",
        category: "StatsigFeatureFlagInitialiser"
    )

    private init() {}

    public static func start(config: StatsigFeatureFlagConfig) async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            Statsig.initialize(
                sdkKey: config.apiKey,
                user: StatsigUser(userID: config.userID),
                completion: { error in
                    if let error {
                        Self.logger.error(
                            "Statsig failed to initialise: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    }

                    Self.logger.trace(
                        "Statsig initialised: (user: \(config.userID), environment: \(config.environment.rawValue))"
                    )
                    continuation.resume()
                }
            )
        }
    }
}
