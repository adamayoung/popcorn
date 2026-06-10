//
//  GamesCatalogViewSnapshotTests.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

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
            viewModel: .preview(
                viewState: .ready(
                    .init(games: GameMetadata.mocks)
                )
            )
        )

        verifyViewSnapshot(of: view)
    }

}

private struct NamespaceContainer: View {

    @Namespace var namespace

    let viewModel: GamesCatalogViewModel

    var body: some View {
        NavigationStack {
            GamesCatalogView(viewModel: viewModel, transitionNamespace: namespace)
        }
    }

}
