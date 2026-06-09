//
//  MovieDetailsViewSnapshotTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieDetailsFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("MovieDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct MovieDetailsViewSnapshotTests {

    @Test
    func movieDetailsView() {
        let view = NavigationStack {
            MovieDetailsView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            movie: .mock,
                            recommendedMovies: MoviePreview.mocks,
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
