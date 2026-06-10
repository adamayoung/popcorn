//
//  AppRootDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import Foundation

/// The dependencies required by ``AppRootViewModel``.
///
/// A plain `Sendable` struct of closures providing the startup sequence and
/// per-tab feature-flag reads. Building the production instance with
/// ``live(services:)`` wires these to the app's shared ``AppServices`` graph.
struct AppRootDependencies {

    /// Runs the app's one-time startup sequence (observability + feature-flag
    /// initialisation). Throws if feature-flag initialisation fails.
    var bootstrap: @Sendable () async throws -> Void

    var isExploreEnabled: @Sendable () -> Bool
    var isWatchlistEnabled: @Sendable () -> Bool
    var isGamesEnabled: @Sendable () -> Bool
    var isSearchEnabled: @Sendable () -> Bool
    var isTVListingsEnabled: @Sendable () -> Bool

}

extension AppRootDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Wires the startup sequence (via ``AppBootstrapper``) and the feature flags
    /// (note that search reads `.mediaSearch`) to the shared ``AppServices`` graph.
    static func live(services: AppServices) -> AppRootDependencies {
        let featureFlags = services.featureFlags

        return AppRootDependencies(
            bootstrap: {
                try await AppBootstrapper(services: services).start()
            },
            isExploreEnabled: { featureFlags.isEnabled(.explore) },
            isWatchlistEnabled: { featureFlags.isEnabled(.watchlist) },
            isGamesEnabled: { featureFlags.isEnabled(.games) },
            isSearchEnabled: { featureFlags.isEnabled(.mediaSearch) },
            isTVListingsEnabled: { featureFlags.isEnabled(.tvListings) }
        )
    }

}

#if DEBUG
    extension AppRootDependencies {

        /// Mock dependencies for previews: a no-op bootstrap and all tabs enabled.
        static var preview: AppRootDependencies {
            AppRootDependencies(
                bootstrap: {},
                isExploreEnabled: { true },
                isWatchlistEnabled: { true },
                isGamesEnabled: { true },
                isSearchEnabled: { true },
                isTVListingsEnabled: { true }
            )
        }

    }
#endif
