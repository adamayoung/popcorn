//
//  AppRootClient.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import FeatureAccess
import Foundation
import Observability
import OSLog

@DependencyClient
struct AppRootClient: Sendable {

    var setupObservability: @Sendable () async throws -> Void
    var setupFeatureFlags: @Sendable () async throws -> Void

    var isExploreEnabled: @Sendable () throws -> Bool
    var isGamesEnabled: @Sendable () throws -> Bool
    var isSearchEnabled: @Sendable () throws -> Bool

}

extension AppRootClient: DependencyKey {

    private static let logger = Logger.appRoot

    static var liveValue: AppRootClient {
        @Dependency(\.featureFlags) var featureFlags
        @Dependency(\.featureFlagsInitialiser) var featureFlagsInitialiser
        @Dependency(\.observability) var observability
        @Dependency(\.observabilityInitialiser) var observabilityInitialiser

        let userID = AppInstallationIdentifier.userID()
        return AppRootClient(
            setupObservability: {
                guard let dsn = AppConfig.Sentry.dsn else {
                    Self.logger.warning("Sentry DSN not configured. Disabling observability.")
                    return
                }

                guard let environment = AppConfig.Sentry.environment else {
                    Self.logger.warning(
                        "Sentry environment not configured. Disabling observability."
                    )
                    return
                }

                let config = ObservabilityConfiguration(
                    dsn: dsn,
                    environment: environment,
                    userID: userID
                )

                do {
                    try await observabilityInitialiser.start(config)
                } catch let error {
                    Self.logger.error(
                        "Observability failed to initialise: \(error.localizedDescription, privacy: .public)"
                    )
                }
            },
            setupFeatureFlags: {
                guard let apiKey = AppConfig.Statsig.sdkKey else {
                    Self.logger.warning("Statsig SDK key not configured. Disabling feature flags.")
                    return
                }

                guard let environment = AppConfig.Statsig.environment else {
                    Self.logger.warning(
                        "Statsig environment not configured. Disabling feature flags."
                    )
                    return
                }

                let config = FeatureFlagsConfiguration(
                    apiKey: apiKey,
                    environment: environment,
                    userID: userID
                )

                do {
                    try await featureFlagsInitialiser.start(config)
                } catch let error {
                    Self.logger.error(
                        "Feature flags failed to initialise: \(error.localizedDescription, privacy: .public)"
                    )
                    throw error
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
