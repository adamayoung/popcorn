//
//  TrendingTVSeriesViewSnapshotTests.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

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
            TrendingTVSeriesView(viewModel: .preview(tvSeries: TVSeriesPreview.mocks))
        }

        verifyViewSnapshot(of: view)
    }

}
