//
//  PersonCreditsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import PersonCreditsFeature
import SnapshotTestHelpers
import SnapshotTesting
import SwiftUI
import Testing

@Suite("PersonCreditsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct PersonCreditsViewSnapshotTests {

    // The error state is deliberately not snapshotted: a seeded `.error` view
    // state is retried by `.task(id:)` and re-renders before the snapshot is
    // taken. Error handling is covered by the view-model tests instead.

    @Test
    func personCreditsView() {
        let view = NavigationStack {
            PersonCreditsView(
                viewModel: .preview(
                    viewState: .ready(PersonCreditsViewSnapshot(credits: CreditItem.mocks))
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

    @Test
    func personCreditsViewWhenEmpty() {
        let view = NavigationStack {
            PersonCreditsView(
                viewModel: .preview(
                    viewState: .ready(PersonCreditsViewSnapshot(credits: []))
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
