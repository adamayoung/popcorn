//
//  TVSeriesCastAndCrewViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeriesCastAndCrewFeature

@Suite("TVSeriesCastAndCrewViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeriesCastAndCrewViewSnapshotTests {

    @Test
    func tvSeriesCastAndCrewView() {
        let view = NavigationStack {
            TVSeriesCastAndCrewView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            castMembers: CastMember.mocks,
                            crewByDepartment: CrewDepartment.mocks
                        )
                    )
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
