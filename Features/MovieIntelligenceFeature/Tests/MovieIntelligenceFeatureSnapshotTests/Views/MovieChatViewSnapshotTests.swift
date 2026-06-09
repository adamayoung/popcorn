//
//  MovieChatViewSnapshotTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieIntelligenceFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("MovieChatViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct MovieChatViewSnapshotTests {

    @Test
    func movieChatView() {
        let view = MovieIntelligenceView(
            viewModel: .preview(messages: Message.mocks)
        )

        verifyViewSnapshot(of: view)
    }

}
