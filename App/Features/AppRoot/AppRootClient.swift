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

@DependencyClient
struct AppRootClient: Sendable {

    private static let logger = Logger(
        subsystem: "Popcorn",
        category: "AppRootClient"
    )

    var startFeatureFlags: @Sendable () async throws -> Void

    var isExploreEnabled: @Sendable () throws -> Bool
    var isGamesEnabled: @Sendable () throws -> Bool
    var isSearchEnabled: @Sendable () throws -> Bool

}

extension AppRootClient: DependencyKey {

    static var liveValue: AppRootClient {
        @Dependency(\.featureFlags) var featureFlags
        @Dependency(\.featureFlagsInitialiser) var featureFlagsInitialiser

        return AppRootClient(
            startFeatureFlags: {
                let userID = AppInstallationIdentifier.userID()
                let config = FeatureFlagsConfiguration(
                    userID: userID,
                    environment: AppConfig.featureFlagsEnvironment,
                    apiKey: AppConfig.featureFlagsKey
                )

                return try await featureFlagsInitialiser.start(config)
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
