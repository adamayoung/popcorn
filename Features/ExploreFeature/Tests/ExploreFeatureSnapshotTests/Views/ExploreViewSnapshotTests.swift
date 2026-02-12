//
//  ExploreViewSnapshotTests.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
@testable import ExploreFeature
import SDWebImage
import SnapshotTesting
import SwiftUI
import Testing

@Suite("ExploreViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct ExploreViewSnapshotTests {

    @Test
    func exploreView() {
        let view = NavigationStack {
            ExploreView(
                store: Store(
                    initialState: .init(
                        viewState: .ready(
                            .init(
                                discoverMovies: MoviePreview.snapshots,
                                trendingMovies: MoviePreview.snapshots,
                                popularMovies: MoviePreview.snapshots,
                                trendingTVSeries: TVSeriesPreview.mocks,
                                trendingPeople: PersonPreview.mocks
                            )
                        )
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }

}

extension MoviePreview {

    static var snapshots: [MoviePreview] {
        [
            MoviePreview(
                id: 1,
                title: "Superman",
                posterURL: URL(string: "https://test.local/superman-poster.jpg"),
                backdropURL: URL(string: "https://test.local/superman-backdrop.jpg"),
                logoURL: nil
            )
        ]
    }

}
