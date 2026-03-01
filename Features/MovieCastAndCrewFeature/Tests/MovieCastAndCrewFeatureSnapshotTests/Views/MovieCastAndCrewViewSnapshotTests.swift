//
//  MovieCastAndCrewViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import MovieCastAndCrewFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("MovieCastAndCrewViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct MovieCastAndCrewViewSnapshotTests {

    @Test
    func movieCastAndCrewView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: MovieCastAndCrewFeature.State(
                    movieID: 798_645,
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

    let store: StoreOf<MovieCastAndCrewFeature>

    var body: some View {
        NavigationStack {
            MovieCastAndCrewView(store: store, transitionNamespace: namespace)
        }
    }

}
