//
//  AppRootViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import Popcorn
import Synchronization
import Testing

@MainActor
@Suite("AppRootViewModel Tests")
struct AppRootViewModelTests {

    // MARK: - start success

    @Test("start runs bootstrap, applies feature flags, then marks ready")
    func startAppliesFeatureFlagsAndBecomesReady() async {
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isExploreEnabled: true,
                isWatchlistEnabled: true,
                isGamesEnabled: false,
                isSearchEnabled: true,
                isTVListingsEnabled: false
            )
        )

        await viewModel.start()

        #expect(viewModel.isExploreEnabled == true)
        #expect(viewModel.isWatchlistEnabled == true)
        #expect(viewModel.isGamesEnabled == false)
        #expect(viewModel.isSearchEnabled == true)
        #expect(viewModel.isTVListingsEnabled == false)
        #expect(viewModel.isReady == true)
        #expect(viewModel.error == nil)
    }

    @Test("start with all flags disabled leaves every tab hidden but app ready")
    func startWithAllFlagsDisabled() async {
        let viewModel = AppRootViewModel(dependencies: .stub())

        await viewModel.start()

        #expect(viewModel.isExploreEnabled == false)
        #expect(viewModel.isWatchlistEnabled == false)
        #expect(viewModel.isGamesEnabled == false)
        #expect(viewModel.isSearchEnabled == false)
        #expect(viewModel.isTVListingsEnabled == false)
        #expect(viewModel.isReady == true)
    }

    @Test("start runs bootstrap exactly once")
    func startRunsBootstrapOnce() async {
        let counter = BootstrapCounter()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isExploreEnabled: true,
                bootstrap: { await counter.increment() }
            )
        )

        await viewModel.start()
        await viewModel.start()

        #expect(await counter.count == 1)
        #expect(viewModel.isReady == true)
    }

    // MARK: - start failure

    @Test("start records the error and stays not-ready when bootstrap throws")
    func startWithFailingBootstrapSetsError() async {
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isExploreEnabled: true,
                bootstrap: { throw StubError.bootstrapFailed }
            )
        )

        await viewModel.start()

        #expect(viewModel.error as? StubError == .bootstrapFailed)
        #expect(viewModel.isReady == false)
        // Feature flags are only read after a successful bootstrap.
        #expect(viewModel.isExploreEnabled == false)
    }

    // MARK: - automatic TV-listings sync

    @Test("start triggers a TV-listings sync when the feature is enabled")
    func startTriggersSyncWhenEnabled() async {
        let recorder = SyncRecorder()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: { _ in await recorder.record() }
            )
        )

        await viewModel.start()

        #expect(await recorder.recordCount == 1)
    }

    @Test("a completed sync bumps tvListingsRevision so the view can refresh")
    func completedSyncBumpsRevision() async {
        let viewModel = AppRootViewModel(
            dependencies: .stub(isTVListingsEnabled: true, syncTVListingsIfNeeded: { _ in })
        )

        await viewModel.start()
        #expect(viewModel.tvListingsRevision == 1)

        await viewModel.syncTVListingsIfNeeded()
        #expect(viewModel.tvListingsRevision == 2)
    }

    @Test("start does not trigger a sync when the feature is disabled")
    func startDoesNotTriggerSyncWhenDisabled() async {
        let recorder = SyncRecorder()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: false,
                syncTVListingsIfNeeded: { _ in await recorder.record() }
            )
        )

        await viewModel.start()

        #expect(await recorder.recordCount == 0)
    }

    @Test("syncTVListingsIfNeeded is a no-op before the app is ready")
    func syncIsNoOpBeforeReady() async {
        let recorder = SyncRecorder()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: { _ in await recorder.record() }
            )
        )

        await viewModel.syncTVListingsIfNeeded()

        #expect(await recorder.recordCount == 0)
    }

    @Test("overlapping sync triggers coalesce onto a single run")
    func overlappingSyncsCoalesce() async {
        let recorder = SyncRecorder()
        let entered = TestSignal()
        let release = TestSignal()
        let coalesced = TestSignal()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: { _ in
                    await entered.signal()
                    await release.wait()
                    await recorder.record()
                }
            ),
            onTVListingsCoalesce: { Task { await coalesced.signal() } }
        )

        // `start()` becomes ready then blocks on the gated sync (run #1).
        let startTask = Task { await viewModel.start() }
        await entered.wait()
        // A concurrent foreground trigger must coalesce onto the in-flight run. Wait for the
        // coalesce hook (deterministic) rather than relying on Task.yield scheduling.
        let foregroundTask = Task { await viewModel.syncTVListingsIfNeeded() }
        await coalesced.wait()
        await release.signal()

        await startTask.value
        await foregroundTask.value

        #expect(await recorder.recordCount == 1)
    }

    // MARK: - TV-listings sync progress

    @Test("tvListingsSyncProgress is nil before any sync")
    func syncProgressNilInitially() {
        let viewModel = AppRootViewModel(dependencies: .stub())

        #expect(viewModel.tvListingsSyncProgress == nil)
    }

    @Test("sync progress is reflected while a sync is in flight, then cleared on completion")
    func syncProgressReflectedWhileInFlight() async {
        let release = TestSignal()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: { onProgress in
                    onProgress(0.5)
                    await release.wait()
                }
            )
        )

        // `start()` awaits the gated sync, so run it in the background to observe mid-flight.
        let startTask = Task { await viewModel.start() }
        await waitUntil { viewModel.tvListingsSyncProgress == 0.5 }

        #expect(viewModel.tvListingsSyncProgress == 0.5)

        await release.signal()
        await startTask.value

        #expect(viewModel.tvListingsSyncProgress == nil, "progress is cleared once the sync finishes")
        #expect(viewModel.tvListingsRevision == 1)
    }

    @Test("a progress value delivered after the sync finishes does not resurrect the bar")
    func lateProgressDoesNotResurrect() async {
        let storedCallback = Mutex<(@Sendable (Float) -> Void)?>(nil)
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: { onProgress in
                    // Keep the callback to fire it *after* the sync has completed.
                    storedCallback.withLock { $0 = onProgress }
                }
            )
        )

        await viewModel.start()
        #expect(viewModel.tvListingsSyncProgress == nil)

        // A straggler delivery from this run must be ignored by the generation guard.
        storedCallback.withLock { $0 }?(0.9)
        await yieldRepeatedly()

        #expect(viewModel.tvListingsSyncProgress == nil)
    }

    // MARK: - selectedTab

    @Test("selectedTab defaults to explore")
    func selectedTabDefaultsToExplore() {
        let viewModel = AppRootViewModel(dependencies: .stub())

        #expect(viewModel.selectedTab == .explore)
    }

    // MARK: - Async helpers

    /// Yields until `condition` holds, letting the progress callback's `@MainActor` hop run.
    /// Both this suite and the hop are on the main actor, so a bounded yield loop drains it
    /// deterministically without relying on wall-clock timing.
    private func waitUntil(iterations: Int = 1000, _ condition: () -> Bool) async {
        var remaining = iterations
        while !condition(), remaining > 0 {
            await Task.yield()
            remaining -= 1
        }
    }

    /// Yields a handful of times to give any enqueued `@MainActor` work a chance to run.
    private func yieldRepeatedly(times: Int = 50) async {
        for _ in 0 ..< times {
            await Task.yield()
        }
    }

}

// MARK: - Test Helpers

private enum StubError: Error, Equatable {
    case bootstrapFailed
}

private actor BootstrapCounter {
    private(set) var count = 0

    func increment() {
        count += 1
    }
}

private actor SyncRecorder {
    private(set) var recordCount = 0

    func record() {
        recordCount += 1
    }
}

/// A one-shot async signal used to gate the coalescing test deterministically.
private actor TestSignal {
    private var isSignalled = false
    private var continuations: [CheckedContinuation<Void, Never>] = []

    func wait() async {
        if isSignalled {
            return
        }
        await withCheckedContinuation { continuations.append($0) }
    }

    func signal() {
        isSignalled = true
        let pending = continuations
        continuations.removeAll()
        for continuation in pending {
            continuation.resume()
        }
    }
}

private extension AppRootDependencies {

    static func stub(
        isExploreEnabled: Bool = false,
        isWatchlistEnabled: Bool = false,
        isGamesEnabled: Bool = false,
        isSearchEnabled: Bool = false,
        isTVListingsEnabled: Bool = false,
        bootstrap: @escaping @Sendable () async throws -> Void = {},
        syncTVListingsIfNeeded: @escaping @Sendable (@escaping @Sendable (Float) -> Void) async -> Void = { _ in }
    ) -> AppRootDependencies {
        AppRootDependencies(
            bootstrap: bootstrap,
            isExploreEnabled: { isExploreEnabled },
            isWatchlistEnabled: { isWatchlistEnabled },
            isGamesEnabled: { isGamesEnabled },
            isSearchEnabled: { isSearchEnabled },
            isTVListingsEnabled: { isTVListingsEnabled },
            syncTVListingsIfNeeded: syncTVListingsIfNeeded
        )
    }

}
