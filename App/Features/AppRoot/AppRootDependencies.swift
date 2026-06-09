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
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `AppRootClient` (`@DependencyClient`). Building the production instance with
/// ``live(services:)`` wires the one-time startup sequence (``bootstrap``) and the
/// per-tab feature-flag reads to the app's shared ``AppServices`` graph.
struct AppRootDependencies: Sendable {

    /// Runs the app's one-time startup sequence (observability + feature-flag
    /// initialisation). Throws if feature-flag initialisation fails.
    var bootstrap: @Sendable () async throws -> Void

    var isExploreEnabled: @Sendable () -> Bool
    var isWatchlistEnabled: @Sendable () -> Bool
    var isGamesEnabled: @Sendable () -> Bool
    var isSearchEnabled: @Sendable () -> Bool
    var isTVListingsEnabled: @Sendable () -> Bool

    init(
        bootstrap: @escaping @Sendable () async throws -> Void,
        isExploreEnabled: @escaping @Sendable () -> Bool,
        isWatchlistEnabled: @escaping @Sendable () -> Bool,
        isGamesEnabled: @escaping @Sendable () -> Bool,
        isSearchEnabled: @escaping @Sendable () -> Bool,
        isTVListingsEnabled: @escaping @Sendable () -> Bool
    ) {
        self.bootstrap = bootstrap
        self.isExploreEnabled = isExploreEnabled
        self.isWatchlistEnabled = isWatchlistEnabled
        self.isGamesEnabled = isGamesEnabled
        self.isSearchEnabled = isSearchEnabled
        self.isTVListingsEnabled = isTVListingsEnabled
    }

}

extension AppRootDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `AppRootClient.liveValue` exactly: the same startup
    /// sequence (via ``AppBootstrapper``) and the same feature flags (note that
    /// search reads `.mediaSearch`).
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
