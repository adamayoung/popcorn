//
//  AppRootViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation

/// Drives ``AppRootView``. The MVVM replacement for `AppRootFeature`.
///
/// Owns the selected tab, the per-tab feature-flag visibility, and the one-time
/// startup lifecycle. ``start()`` runs the bootstrap sequence once (observability +
/// feature-flag initialisation), then reads the feature flags and marks the app
/// ready. If bootstrap throws, ``error`` is set and the app stays not-ready, which
/// the view renders as the error state — matching the former reducer's behaviour.
@Observable
@MainActor
final class AppRootViewModel {

    /// The tabs hosted by the root tab view. Moved here from `AppRootFeature.Tab`;
    /// the `id`s are unchanged so tab customisation identifiers remain stable.
    enum Tab: Equatable, Hashable {
        case explore
        case watchlist
        case games
        case search
        case tvListings

        var id: String {
            switch self {
            case .explore: "popcorn.tab.explore"
            case .watchlist: "popcorn.tab.watchlist"
            case .games: "popcorn.tab.games"
            case .search: "popcorn.tab.search"
            case .tvListings: "popcorn.tab.tvlistings"
            }
        }
    }

    /// The selected tab. Bindable so the `TabView` can drive it.
    var selectedTab: Tab = .explore

    private(set) var isExploreEnabled = false
    private(set) var isWatchlistEnabled = false
    private(set) var isGamesEnabled = false
    private(set) var isSearchEnabled = false
    private(set) var isTVListingsEnabled = false

    private(set) var isReady = false
    private(set) var error: Error?

    #if DEBUG
        var isPresentingDeveloper = false
    #endif

    private var hasStarted = false

    private let dependencies: AppRootDependencies

    init(dependencies: AppRootDependencies) {
        self.dependencies = dependencies
    }

    /// Runs the one-time startup sequence. A no-op after the first call.
    ///
    /// On success: reads the feature flags, then marks the app ready. On failure:
    /// records the error and leaves the app not-ready so the view shows the error
    /// state. Mirrors the former reducer's `setupComplete`/`setupFailed` handling
    /// (feature flags are updated *before* `isReady` is set).
    func start() async {
        guard !hasStarted else {
            return
        }

        hasStarted = true

        do {
            try await dependencies.bootstrap()
            updateFeatureFlags()
            isReady = true
        } catch {
            self.error = error
        }
    }

    private func updateFeatureFlags() {
        isExploreEnabled = dependencies.isExploreEnabled()
        isWatchlistEnabled = dependencies.isWatchlistEnabled()
        isGamesEnabled = dependencies.isGamesEnabled()
        isSearchEnabled = dependencies.isSearchEnabled()
        isTVListingsEnabled = dependencies.isTVListingsEnabled()
    }

    #if DEBUG
        func presentDeveloper() {
            isPresentingDeveloper = true
        }
    #endif

}
