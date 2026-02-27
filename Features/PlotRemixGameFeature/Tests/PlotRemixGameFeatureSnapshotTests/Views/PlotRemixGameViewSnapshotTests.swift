//
//  PlotRemixGameViewSnapshotTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import Foundation
@testable import PlotRemixGameFeature
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("PlotRemixGameViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct PlotRemixGameViewSnapshotTests {

    @Test
    func plotRemixGameView() {
        let view = NamespaceContainer(
            store: Store(
                initialState: PlotRemixGameFeature.State(
                    gameID: 1,
                    metadata: .mock
                ),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view.environment(\.meshAnimationPaused, true))
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let store: StoreOf<PlotRemixGameFeature>

    var body: some View {
        PlotRemixGameView(store: store, transitionNamespace: namespace)
    }

}
