//
//  ExploreViewSnapshotTests.swift
//  ExploreFeature
//
//  Created by Adam Young on 19/12/2025.
//

import ComposableArchitecture
import SDWebImage
import SnapshotTesting
import SwiftUI
import Testing

@testable import ExploreFeature

@Suite("ExploreViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct ExploreViewSnapshotTests {

    @Test
    func exploreView() async throws {
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
