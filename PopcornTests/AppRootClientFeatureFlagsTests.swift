//
//  AppRootClientFeatureFlagsTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import FeatureAccess
import Foundation
@testable import Popcorn
import Testing

@Suite("AppRootClient Feature Flag Tests")
struct AppRootClientFeatureFlagsTests {

    // MARK: - isExploreEnabled

    @Test("isExploreEnabled returns true when feature flag is enabled")
    func isExploreEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [.explore])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isExploreEnabled() == true)
    }

    @Test("isExploreEnabled returns false when feature flag is disabled")
    func isExploreEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isExploreEnabled() == false)
    }

    // MARK: - isWatchlistEnabled

    @Test("isWatchlistEnabled returns true when feature flag is enabled")
    func isWatchlistEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [.watchlist])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isWatchlistEnabled() == true)
    }

    @Test("isWatchlistEnabled returns false when feature flag is disabled")
    func isWatchlistEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isWatchlistEnabled() == false)
    }

    // MARK: - isGamesEnabled

    @Test("isGamesEnabled returns true when feature flag is enabled")
    func isGamesEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [.games])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isGamesEnabled() == true)
    }

    @Test("isGamesEnabled returns false when feature flag is disabled")
    func isGamesEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isGamesEnabled() == false)
    }

    // MARK: - isSearchEnabled

    @Test("isSearchEnabled returns true when feature flag is enabled")
    func isSearchEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [.mediaSearch])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isSearchEnabled() == true)
    }

    @Test("isSearchEnabled returns false when feature flag is disabled")
    func isSearchEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isSearchEnabled() == false)
    }

    // MARK: - isTVListingsEnabled

    @Test("isTVListingsEnabled returns true when feature flag is enabled")
    func isTVListingsEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [.tvListings])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isTVListingsEnabled() == true)
    }

    @Test("isTVListingsEnabled returns false when feature flag is disabled")
    func isTVListingsEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.featureFlags = StubFeatureFlags(enabledFlags: [])
        } operation: {
            AppRootClient.liveValue
        }

        #expect(try client.isTVListingsEnabled() == false)
    }

}

// MARK: - Test Helpers

private struct StubFeatureFlags: FeatureFlagging {
    let isInitialised: Bool = true
    let enabledFlags: Set<FeatureFlag>

    func isEnabled(_ featureFlag: FeatureFlag) -> Bool {
        enabledFlags.contains(featureFlag)
    }
}
