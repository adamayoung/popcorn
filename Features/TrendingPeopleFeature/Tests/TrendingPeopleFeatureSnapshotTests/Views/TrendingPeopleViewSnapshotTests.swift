//
//  TrendingPeopleViewSnapshotTests.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TrendingPeopleFeature

@Suite("TrendingPeopleViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TrendingPeopleViewSnapshotTests {

    @Test
    func trendingPeopleView() {
        let view = NavigationStack {
            TrendingPeopleView(
                store: Store(
                    initialState: TrendingPeopleFeature.State(
                        people: PersonPreview.mocks
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
