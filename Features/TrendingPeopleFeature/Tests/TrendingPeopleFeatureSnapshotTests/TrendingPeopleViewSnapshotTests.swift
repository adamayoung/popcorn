//
//  TrendingPeopleViewSnapshotTests.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

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
                viewModel: .preview(people: PersonPreview.mocks)
            )
        }

        verifyViewSnapshot(of: view)
    }

}
