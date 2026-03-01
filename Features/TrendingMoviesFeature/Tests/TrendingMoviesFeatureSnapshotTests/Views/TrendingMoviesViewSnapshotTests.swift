//
//  TrendingMoviesViewSnapshotTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
            store: Store(
                initialState: TrendingMoviesFeature.State(
                    movies: MoviePreview.mocks
                ),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view)
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let store: StoreOf<TrendingMoviesFeature>

    var body: some View {
        NavigationStack {
            TrendingMoviesView(store: store, transitionNamespace: namespace)
        }
    }

}
