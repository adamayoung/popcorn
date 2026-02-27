//
//  TVEpisodeDetailsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
                store: Store(
                    initialState: TVEpisodeDetailsFeature.State(
                        tvSeriesID: 1396,
                        seasonNumber: 1,
                        episodeNumber: 1,
                        episodeName: "Pilot",
                        viewState: .ready(
                            .init(
                                name: "Pilot",
                                // swiftlint:disable:next line_length
                                overview: "A high school chemistry teacher diagnosed with lung cancer teams up with a former student to manufacture and sell crystal meth.",
                                airDate: Date(timeIntervalSince1970: 1_200_528_000),
                                stillURL: URL(
                                    string: "https://image.tmdb.org/t/p/original/ydlY3iPfeOAvu8gVqrxPoMvzfBj.jpg"
                                )
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
