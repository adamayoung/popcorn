//
//  MediaSearchViewSnapshotTests.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import MediaSearchFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("MediaSearchViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct MediaSearchViewSnapshotTests {

    @Test
    func mediaSearchView() {
        let view = NavigationStack {
            MediaSearchView(
                store: Store(
                    initialState: MediaSearchFeature.State(
                        viewState: .searchResults(
                            .init(
                                query: "stranger",
                                results: MediaPreview.mocks
                            )
                        ),
                        query: "stranger"
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        verifyViewSnapshot(of: view)
    }

}
