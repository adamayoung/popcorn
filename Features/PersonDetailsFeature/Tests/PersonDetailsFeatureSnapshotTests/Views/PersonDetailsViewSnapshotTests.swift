//
//  PersonDetailsViewSnapshotTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import PersonDetailsFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("PersonDetailsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct PersonDetailsViewSnapshotTests {

    @Test
    func personDetailsView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: PersonDetailsFeature.State(
                    personID: Person.mock.id,
                    viewState: .ready(
                        .init(person: .mock)
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

    let store: StoreOf<PersonDetailsFeature>

    var body: some View {
        NavigationStack {
            PersonDetailsView(store: store, transitionNamespace: namespace)
        }
    }

}
