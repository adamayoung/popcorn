//
//  WatchlistViewSnapshotTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import WatchlistFeature

@Suite("WatchlistViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct WatchlistViewSnapshotTests {

    @Test
    func watchlistView() {
        let view = NamespaceContainer(
            viewModel: .preview(
                viewState: .ready(
                    .init(movies: MoviePreview.mocks)
                )
            )
        )

        verifyViewSnapshot(of: view)
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let viewModel: WatchlistViewModel

    var body: some View {
        NavigationStack {
            WatchlistView(viewModel: viewModel, transitionNamespace: namespace)
        }
    }

}
