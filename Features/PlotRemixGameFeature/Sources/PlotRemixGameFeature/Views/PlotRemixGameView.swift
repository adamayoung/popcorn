//
//  PlotRemixGameView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PlotRemixGameView: View {

    @Bindable private var store: StoreOf<PlotRemixGameFeature>
    private let namespace: Namespace.ID

    private var metadata: GameMetadata? {
        store.metadata
    }

    private var backgroundColor: Color {
        store.metadata?.color ?? .black
    }

    public init(
        store: StoreOf<PlotRemixGameFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if let game = store.game {
                    PlotRemixGameQuestionsView(questions: game.questions)
                } else if let metadata = store.metadata {
                    PlotRemixGameStartView(
                        metadata: metadata,
                        progress: store.generatingProgress
                    ) {
                        store.send(.generateGame)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background {
                AnimatedMeshBackground(baseColor: backgroundColor)
                    .ignoresSafeArea()
            }
            .overlay {
                if store.isLoading {
                    loadingBody
                }
            }
            .task {
                store.send(.fetchMetadata)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) {
                        store.send(.close)
                    }
                }
            }
        }
    }

}

extension PlotRemixGameView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        PlotRemixGameView(
            store: Store(
                initialState: PlotRemixGameFeature.State(
                    gameID: GameMetadata.mock.id
                ),
                reducer: {
                    EmptyReducer()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
