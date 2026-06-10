//
//  PlotRemixGameViewSnapshotTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

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
            viewModel: .preview(
                gameID: 1,
                metadata: .mock
            )
        )

        verifyViewSnapshot(of: view.environment(\.meshAnimationPaused, true))
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let viewModel: PlotRemixGameViewModel

    var body: some View {
        PlotRemixGameView(viewModel: viewModel, transitionNamespace: namespace)
    }

}
