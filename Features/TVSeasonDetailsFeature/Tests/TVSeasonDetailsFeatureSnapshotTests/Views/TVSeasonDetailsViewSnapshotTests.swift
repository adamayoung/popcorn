//
//  TVSeasonDetailsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeasonDetailsFeature

@Suite("TVSeasonDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeasonDetailsViewSnapshotTests {

    @Test
    func tvSeasonDetailsView() {
        let view = NavigationStack {
            TVSeasonDetailsView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            season: TVSeason.mock,
                            episodes: TVEpisode.mocks
                        )
                    )
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
