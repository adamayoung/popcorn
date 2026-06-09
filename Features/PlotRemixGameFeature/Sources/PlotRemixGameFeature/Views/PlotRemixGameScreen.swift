//
//  PlotRemixGameScreen.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM Plot Remix game screen, driven by ``PlotRemixGameViewModel``.
///
/// Reuses the same ``PlotRemixGameStartView`` / ``PlotRemixGameQuestionsView`` and
/// reproduces the exact chrome of the former `PlotRemixGameView`, so recorded
/// snapshots stay byte-identical.
public struct PlotRemixGameScreen: View {

    @State private var viewModel: PlotRemixGameViewModel
    private let namespace: Namespace.ID

    private var backgroundColor: Color {
        viewModel.metadata?.color ?? .black
    }

    public init(
        viewModel: PlotRemixGameViewModel,
        transitionNamespace: Namespace.ID
    ) {
        _viewModel = State(initialValue: viewModel)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if let game = viewModel.game {
                    PlotRemixGameQuestionsView(questions: game.questions)
                } else if let metadata = viewModel.metadata {
                    PlotRemixGameStartView(
                        metadata: metadata,
                        progress: viewModel.generatingProgress
                    ) {
                        viewModel.startGenerating()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background {
                AnimatedMeshBackground(baseColor: backgroundColor)
                    .ignoresSafeArea()
            }
            .overlay {
                if viewModel.isLoading {
                    loadingBody
                }
            }
            .task {
                await viewModel.fetchMetadata()
            }
            .task(id: viewModel.generateToken) {
                await viewModel.generateGame()
            }
            .toolbar {
                ToolbarItem {
                    Button(role: .close) {
                        Task { await viewModel.close() }
                    }
                }
            }
        }
    }

}

extension PlotRemixGameScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

#if DEBUG
    #Preview("Start") {
        @Previewable @Namespace var namespace

        PlotRemixGameScreen(
            viewModel: .preview(metadata: GameMetadata.mock),
            transitionNamespace: namespace
        )
    }
#endif
