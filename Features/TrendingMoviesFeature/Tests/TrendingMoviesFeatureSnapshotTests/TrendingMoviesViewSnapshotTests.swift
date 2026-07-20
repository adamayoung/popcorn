//
//  TrendingMoviesViewSnapshotTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TrendingMoviesFeature

@Suite("TrendingMoviesViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TrendingMoviesViewSnapshotTests {

    @Test
    func trendingMoviesView() {
        let view = NamespaceContainer(
            viewModel: .preview(movies: MoviePreview.mocks)
        )

        verifyViewSnapshot(of: view)
    }

    @Test
    func trendingMoviesViewWhenEmpty() {
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
    // `TrendingMoviesViewModelTests.loadFailureSetsError`.

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let viewModel: TrendingMoviesViewModel

    var body: some View {
        NavigationStack {
            TrendingMoviesView(viewModel: viewModel, transitionNamespace: namespace)
        }
    }

}
