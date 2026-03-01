//
//  TVSeriesChatViewSnapshotTests.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeriesIntelligenceFeature

@Suite("TVSeriesChatViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeriesChatViewSnapshotTests {

    @Test
    func tvSeriesChatView() {
        let view = TVSeriesChatView(
            store: Store(
                initialState: TVSeriesIntelligenceFeature.State(
                    tvSeriesID: 1396,
                    messages: Message.mocks
                ),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view)
    }

}
