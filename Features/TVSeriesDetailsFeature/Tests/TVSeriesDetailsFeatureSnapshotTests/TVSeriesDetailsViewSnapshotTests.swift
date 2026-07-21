//
//  TVSeriesDetailsViewSnapshotTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeriesDetailsFeature

@Suite("TVSeriesDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeriesDetailsViewSnapshotTests {

    @Test
    func tvSeriesDetailsView() {
        let view = NavigationStack {
            TVSeriesDetailsView(
                viewModel: .preview(
                    viewState: .ready(.mock),
                    castAndCrewState: .ready(.mock)
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

    // Note: a "cast & crew loading" snapshot was intentionally not added. The stretchy
    // header fills the viewport, so the carousel placeholder sits below the fold and
    // isn't captured — the loading state is covered by TVSeriesDetailsViewModelTests instead.

}
