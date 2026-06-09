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

private extension AppRootDependencies {

    static func stub(
        isExploreEnabled: Bool = false,
        isWatchlistEnabled: Bool = false,
        isGamesEnabled: Bool = false,
        isSearchEnabled: Bool = false,
        isTVListingsEnabled: Bool = false,
        bootstrap: @escaping @Sendable () async throws -> Void = {}
    ) -> AppRootDependencies {
        AppRootDependencies(
            bootstrap: bootstrap,
            isExploreEnabled: { isExploreEnabled },
            isWatchlistEnabled: { isWatchlistEnabled },
            isGamesEnabled: { isGamesEnabled },
            isSearchEnabled: { isSearchEnabled },
            isTVListingsEnabled: { isTVListingsEnabled }
        )
    }

}
