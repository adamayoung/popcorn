//
//  GamesCatalogViewSnapshotTests.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import GamesCatalogFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("GamesCatalogViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct GamesCatalogViewSnapshotTests {

    @Test
    func gamesCatalogView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: GamesCatalogFeature.State(
                    viewState: .ready(
                        .init(games: GameMetadata.mocks)
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

    let store: StoreOf<GamesCatalogFeature>

    var body: some View {
        NavigationStack {
            GamesCatalogView(store: store, transitionNamespace: namespace)
        }
    }

}
