//
//  MovieCastAndCrewViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieCastAndCrewFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("MovieCastAndCrewViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct MovieCastAndCrewViewSnapshotTests {

    @Test
    func movieCastAndCrewView() {
        let view = NavigationStack {
            MovieCastAndCrewView(
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
