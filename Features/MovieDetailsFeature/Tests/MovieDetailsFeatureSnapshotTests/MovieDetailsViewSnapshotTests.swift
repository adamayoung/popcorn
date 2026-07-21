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
                    viewState: .ready(.mock),
                    recommendedMoviesState: .ready(MoviePreview.mocks),
                    castAndCrewState: .ready(.mock)
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

    // Note: a "sections loading" snapshot was intentionally not added. The stretchy
    // header fills the viewport, so the carousel placeholders sit below the fold and
    // aren't captured — the loading state is covered by MovieDetailsViewModelTests instead.

}
