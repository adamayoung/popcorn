//
//  AppRootViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation

/// Drives ``AppRootView``.
///
/// Owns the selected tab, the per-tab feature-flag visibility, and the one-time
/// startup lifecycle. ``start()`` runs the bootstrap sequence once (observability +
/// feature-flag initialisation), then reads the feature flags and marks the app
/// ready. If bootstrap throws, ``error`` is set and the app stays not-ready, which
/// the view renders as the error state.
@Observable
@MainActor
final class AppRootViewModel {

    /// The tabs hosted by the root tab view. The `id`s are stable so tab
    /// customisation identifiers are preserved across launches.
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

    /// Bumped after each automatic TV-listings sync completes. ``AppRootView`` observes it
    /// to refresh the listings view once the launch sync has populated the cache — otherwise
    /// the view, shown the moment `isReady` flips, would keep displaying the pre-sync (empty)
    /// cache until the next foreground.
    private(set) var tvListingsRevision = 0

    private var hasStarted = false

    /// The in-flight automatic sync, reused by overlapping triggers (launch + foreground)
    /// so the cold-launch double-fire coalesces onto a single run.
    private var tvListingsSyncTask: Task<Void, Never>?

    private let dependencies: AppRootDependencies

    init(dependencies: AppRootDependencies) {
        self.dependencies = dependencies
    }

    /// Runs the one-time startup sequence. A no-op after the first call.
    ///
    /// On success: reads the feature flags, then marks the app ready (feature flags
    /// are updated *before* `isReady` is set). On failure: records the error and
    /// leaves the app not-ready so the view shows the error state.
    func start() async {
        guard !hasStarted else {
            return
        }

        hasStarted = true

        do {
            try await dependencies.bootstrap()
            updateFeatureFlags()
            isReady = true
            await syncTVListingsIfNeeded()
        } catch {
            self.error = error
        }
    }

    /// Triggers a throttled TV-listings sync, gated on the app being ready and the feature
    /// enabled. Overlapping calls (launch + foreground `.active`) coalesce onto one task.
    /// A scene activation that fires before bootstrap completes is an intentional no-op;
    /// `start()` is the authoritative launch trigger.
    func syncTVListingsIfNeeded() async {
        guard isReady, isTVListingsEnabled else {
            return
        }

        if let tvListingsSyncTask {
            await tvListingsSyncTask.value
            return
        }

        let task = Task { await dependencies.syncTVListingsIfNeeded() }
        tvListingsSyncTask = task
        await task.value
        tvListingsSyncTask = nil

        // Signal completion so the listings view can pick up the freshly-synced cache.
        tvListingsRevision += 1
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
