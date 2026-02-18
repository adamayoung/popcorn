//
//  WatchlistFeatureNavigationTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import WatchlistFeature

@MainActor
@Suite("WatchlistFeature navigation Tests")
struct WatchlistFeatureNavigationTests {

    @Test("navigate movieDetails does not change state")
    func navigateMovieDetailsDoesNotChangeState() async {
        let store = TestStore(
            initialState: WatchlistFeature.State()
        ) {
            WatchlistFeature()
        }

        await store.send(.navigate(.movieDetails(id: 123)))
    }

}
