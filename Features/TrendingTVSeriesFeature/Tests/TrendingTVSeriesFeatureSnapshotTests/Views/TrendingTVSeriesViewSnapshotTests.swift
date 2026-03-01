//
//  TrendingTVSeriesViewSnapshotTests.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TrendingTVSeriesFeature

@Suite("TrendingTVSeriesViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TrendingTVSeriesViewSnapshotTests {

    @Test
    func trendingTVSeriesView() {
        let view = NavigationStack {
            TrendingTVSeriesView(
                store: Store(
                    initialState: TrendingTVSeriesFeature.State(
                        tvSeries: TVSeriesPreview.mocks
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
