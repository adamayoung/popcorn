//
//  AppRootClient.swift
//  Popcorn
//
//  Created by Adam Young on 16/12/2025.
//

import AppDependencies
import ComposableArchitecture
import FeatureFlags
import Foundation
import OSLog
import Observability

@DependencyClient
struct AppRootClient: Sendable {

    private static let logger = Logger(
        subsystem: "Popcorn",
        category: "AppRootClient"
    )

    var setupObservability: @Sendable () async throws -> Void
    var setupFeatureFlags: @Sendable () async throws -> Void

    var isExploreEnabled: @Sendable () throws -> Bool
    var isGamesEnabled: @Sendable () throws -> Bool
    var isSearchEnabled: @Sendable () throws -> Bool

}

extension AppRootClient: DependencyKey {

    static var liveValue: AppRootClient {
        @Dependency(\.featureFlags) var featureFlags
        @Dependency(\.featureFlagsInitialiser) var featureFlagsInitialiser
        @Dependency(\.observability) var observability
        @Dependency(\.observabilityInitialiser) var observabilityInitialiser

        let userID = AppInstallationIdentifier.userID()
        return AppRootClient(
            setupObservability: {
                let config = ObservabilityConfiguration(
                    dsn: AppConfig.Sentry.dsn,
                    environment: AppConfig.Sentry.environment,
                    userID: userID
                )

                do {
                    try await observabilityInitialiser.start(config)
                } catch let error {
                    Self.logger.error(
                        "Observability failed to initialise: \(error.localizedDescription)")
                }
            },
            setupFeatureFlags: {
                let config = FeatureFlagsConfiguration(
                    apiKey: AppConfig.Statsig.sdkKey,
                    environment: AppConfig.Statsig.environment,
                    userID: userID
                )

                do {
                    try await featureFlagsInitialiser.start(config)
                } catch let error {
                    Self.logger.error(
                        "Feature flags failed to initialise: \(error.localizedDescription)")
                }
            },
            isExploreEnabled: {
                featureFlags.isEnabled(.explore)
            },
            isGamesEnabled: {
                featureFlags.isEnabled(.games)
            },
            isSearchEnabled: {
                featureFlags.isEnabled(.mediaSearch)
            }
        )
    }

}

extension DependencyValues {

    var appRootClient: AppRootClient {
        get { self[AppRootClient.self] }
        set { self[AppRootClient.self] = newValue }
    }

}
