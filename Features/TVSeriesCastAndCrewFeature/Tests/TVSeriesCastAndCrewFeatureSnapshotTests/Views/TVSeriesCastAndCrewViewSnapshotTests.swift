//
//  TVSeriesCastAndCrewViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing
@testable import TVSeriesCastAndCrewFeature

@Suite("TVSeriesCastAndCrewViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVSeriesCastAndCrewViewSnapshotTests {

    @Test
    func tvSeriesCastAndCrewView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: TVSeriesCastAndCrewFeature.State(
                    tvSeriesID: 66732,
                    viewState: .ready(
                        .init(
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

    let store: StoreOf<TVSeriesCastAndCrewFeature>

    var body: some View {
        NavigationStack {
            TVSeriesCastAndCrewView(store: store, transitionNamespace: namespace)
        }
    }

}
