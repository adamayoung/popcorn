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
                        viewState: .ready(
                            .init(
                                episode: TVEpisode.mock,
                                castMembers: CastMember.mocks,
                                crewMembers: CrewMember.mocks
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
