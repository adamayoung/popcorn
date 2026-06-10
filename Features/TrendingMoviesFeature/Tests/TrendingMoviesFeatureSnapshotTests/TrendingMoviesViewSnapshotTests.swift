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
