//
//  AppServices+Platform.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Caching
import CoreDomain
import FeatureAccess
import FeatureAccessAdapters
import Foundation
import Observability
import ObservabilityAdapters
import ThemeColorProvider
import TMDb

extension AppServices {

    // MARK: - Platform builders

    /// Builds the TMDb client (mirrors `TMDbClient+TCA.liveValue` exactly).
    static func makeTMDbClient(tmdbAPIKey: String?) -> TMDbClient {
        TMDbClient(
            apiKey: tmdbAPIKey ?? TMDbAPIKeyProvider.apiKey(),
            configuration: .init(
                defaultLanguage: Locale.current.language.minimalIdentifier,
                defaultCountry: Locale.current.region?.identifier,
                retry: .default,
                cache: .default
            )
        )
    }

    /// Builds the feature-flag service (one instance, reused for reads + overrides + initialiser).
    static func makeFeatureFlagService()
        -> any FeatureFlagging & FeatureFlagOverriding & FeatureFlagInitialising {
        FeatureAccessAdaptersFactory().makeFeatureFlagsFactory().featureFlagService
    }

    /// Builds the observability service (one instance, reused for reporting + initialiser).
    static func makeObservabilityService() -> any Observing & ObservabilityInitialising {
        ObservabilityAdaptersFactory()
            .makeObservabilityFactory()
            .makeService()
    }

    static func makeThemeColorProvider() -> (any ThemeColorProviding)? {
        let cache = CachesFactory.makeDiskCache(subdirectory: "ThemeColors")
        return DefaultThemeColorProvider(cache: cache)
    }

}
