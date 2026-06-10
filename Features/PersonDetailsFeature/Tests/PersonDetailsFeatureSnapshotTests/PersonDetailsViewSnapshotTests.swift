//
//  PersonDetailsViewSnapshotTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PersonDetailsFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("PersonDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct PersonDetailsViewSnapshotTests {

    @Test
    func personDetailsView() {
        let view = NavigationStack {
            PersonDetailsView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(person: .mock)
                    )
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
