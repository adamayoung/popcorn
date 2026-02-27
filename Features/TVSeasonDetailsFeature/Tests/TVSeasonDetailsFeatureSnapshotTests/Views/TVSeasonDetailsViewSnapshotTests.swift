//
//  TVSeasonDetailsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
                store: Store(
                    initialState: TVSeasonDetailsFeature.State(
                        tvSeriesID: 1396,
                        seasonNumber: 1,
                        seasonName: "Season 1",
                        viewState: .ready(
                            .init(
                                // swiftlint:disable:next line_length
                                overview: "High school chemistry teacher Walter White's life is changed when he is diagnosed with stage III lung cancer.",
                                episodes: TVEpisode.mocks
                            )
                        )
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
