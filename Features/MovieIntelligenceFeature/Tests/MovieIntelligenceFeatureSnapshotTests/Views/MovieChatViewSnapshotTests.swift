//
//  MovieChatViewSnapshotTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
        let view = MovieChatView(
            store: Store(
                initialState: MovieIntelligenceFeature.State(
                    movieID: 550,
                    messages: Message.mocks
                ),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view)
    }

}
