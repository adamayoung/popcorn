//
//  TVEpisodeDetailsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVEpisodeDetailsFeature

@Suite("TVEpisodeDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVEpisodeDetailsViewSnapshotTests {

    @Test
    func tvEpisodeDetailsView() {
        let view = NavigationStack {
            TVEpisodeDetailsView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            episode: TVEpisode.mock,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    )
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
