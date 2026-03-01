//
//  TVSeriesDetailsViewSnapshotTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeriesDetailsFeature

@Suite("TVSeriesDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeriesDetailsViewSnapshotTests {

    @Test
    func tvSeriesDetailsView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: TVSeries.mock.id,
                    viewState: .ready(
                        .init(
                            tvSeries: .mock,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
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

    let store: StoreOf<TVSeriesDetailsFeature>

    var body: some View {
        NavigationStack {
            TVSeriesDetailsView(store: store, transitionNamespace: namespace)
        }
    }

}
