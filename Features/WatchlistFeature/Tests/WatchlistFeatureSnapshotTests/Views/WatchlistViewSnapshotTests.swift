//
//  WatchlistViewSnapshotTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
            store: Store(
                initialState: WatchlistFeature.State(
                    viewState: .ready(
                        .init(movies: MoviePreview.mocks)
                    )
                ),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view)
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let store: StoreOf<WatchlistFeature>

    var body: some View {
        NavigationStack {
            WatchlistView(store: store, transitionNamespace: namespace)
        }
    }

}
