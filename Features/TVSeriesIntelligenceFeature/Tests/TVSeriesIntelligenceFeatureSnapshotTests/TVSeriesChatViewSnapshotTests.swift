//
//  TVSeriesChatViewSnapshotTests.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

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
        let view = TVSeriesIntelligenceView(
            viewModel: .preview(messages: Message.mocks)
        )

        verifyViewSnapshot(of: view)
    }

}
