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

    /// Determinate progress of the in-flight automatic TV-listings sync, as a fraction in
    /// `0...1`, or `nil` when no sync is reporting progress. ``AppRootView`` forwards this to
    /// the listings view, which shows a progress bar on first launch (before today's listings
    /// are cached).
    private(set) var tvListingsSyncProgress: Float?

    /// Bumped each time a sync starts (and again when it finishes). The progress callback only
    /// commits a value whose generation still matches, so a late delivery can't resurrect the
    /// bar after the completion reset.
    private var syncProgressGeneration = 0

    private var hasStarted = false

    /// The in-flight automatic sync, reused by overlapping triggers (launch + foreground)
    /// so the cold-launch double-fire coalesces onto a single run.
    private var tvListingsSyncTask: Task<Void, Never>?

    private let dependencies: AppRootDependencies

    /// Optional observation point fired when a sync trigger coalesces onto an in-flight run.
    /// `nil` in production; a test sets it to observe coalescing without relying on scheduler timing.
    private let onTVListingsCoalesce: (@Sendable () -> Void)?

    init(
        dependencies: AppRootDependencies,
        onTVListingsCoalesce: (@Sendable () -> Void)? = nil
    ) {
        self.dependencies = dependencies
        self.onTVListingsCoalesce = onTVListingsCoalesce
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
            onTVListingsCoalesce?()
            await tvListingsSyncTask.value
            return
        }

        syncProgressGeneration += 1
        let generation = syncProgressGeneration
        let task = Task {
            await dependencies.syncTVListingsIfNeeded { [weak self] value in
                // Hop to the main actor and drop the value if a newer generation has begun
                // (or this sync already finished), so a late delivery can't strand the bar.
                Task { @MainActor in
                    guard let self, self.syncProgressGeneration == generation else {
                        return
                    }
                    // Separately-spawned tasks have no ordering guarantee, so drop a value that
                    // arrived out of order and would move the determinate bar backwards.
                    if let current = self.tvListingsSyncProgress, value < current {
                        return
                    }
                    self.tvListingsSyncProgress = value
                }
            }
        }
        tvListingsSyncTask = task
        await task.value
        tvListingsSyncTask = nil

        // Invalidate any in-flight progress callbacks from this run, then signal completion so
        // the listings view picks up the freshly-synced cache, and finally clear the bar.
        // Bumping the revision before clearing lets the view's re-fetch begin while the bar is
        // still shown, so a successful first sync transitions straight to populated listings.
        syncProgressGeneration += 1
        tvListingsRevision += 1
        tvListingsSyncProgress = nil
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
