//
//  PopularMoviesViewSnapshotTests.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import PopularMoviesFeature

@Suite("PopularMoviesViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct PopularMoviesViewSnapshotTests {

    @Test
    func popularMoviesView() {
        let view = NamespaceContainer(
            viewModel: .preview(movies: MoviePreview.mocks)
        )

        verifyViewSnapshot(of: view)
    }

    @Test
    func popularMoviesViewWhenEmpty() {
        let view = NamespaceContainer(
            viewModel: .preview(movies: [])
        )

        verifyViewSnapshot(of: view)
    }

    // The error state is deliberately not snapshot-tested. Seeding `.error` on a
    // fresh view does not hold: the view's `.task(id:)` runs on first appearance,
    // and `load()` only short-circuits on `.ready`/`.loading`, so an `.error` seed
    // is immediately retried and the snapshot captures a spinner. In production the
    // state is stable — it is reached by a failing `load()`, and `.task` does not
    // rerun until `reload()` bumps `reloadID`. The `.error` transition is covered by
    // `PopularMoviesViewModelTests.loadFailureSetsError`.

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let viewModel: PopularMoviesViewModel

    var body: some View {
        NavigationStack {
            PopularMoviesView(viewModel: viewModel, transitionNamespace: namespace)
        }
    }

}
