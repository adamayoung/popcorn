//
//  AppRootViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import Popcorn
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
                syncTVListingsIfNeeded: { await recorder.record() }
            )
        )

        await viewModel.start()

        #expect(await recorder.recordCount == 1)
    }

    @Test("start does not trigger a sync when the feature is disabled")
    func startDoesNotTriggerSyncWhenDisabled() async {
        let recorder = SyncRecorder()
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: false,
                syncTVListingsIfNeeded: { await recorder.record() }
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
                syncTVListingsIfNeeded: { await recorder.record() }
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
        let viewModel = AppRootViewModel(
            dependencies: .stub(
                isTVListingsEnabled: true,
                syncTVListingsIfNeeded: {
                    await entered.signal()
                    await release.wait()
                    await recorder.record()
                }
            )
        )

        // `start()` becomes ready then blocks on the gated sync (run #1).
        let startTask = Task { await viewModel.start() }
        await entered.wait()
        // A concurrent foreground trigger must coalesce onto the in-flight run.
        let foregroundTask = Task { await viewModel.syncTVListingsIfNeeded() }
        await Task.yield()
        await release.signal()

        await startTask.value
        await foregroundTask.value

        #expect(await recorder.recordCount == 1)
    }

    // MARK: - selectedTab

    @Test("selectedTab defaults to explore")
    func selectedTabDefaultsToExplore() {
        let viewModel = AppRootViewModel(dependencies: .stub())

        #expect(viewModel.selectedTab == .explore)
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
        syncTVListingsIfNeeded: @escaping @Sendable () async -> Void = {}
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
