//
//  PlotRemixGameView.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PlotRemixGameView: View {

    @Bindable private var store: StoreOf<PlotRemixGameFeature>
    private let namespace: Namespace.ID

    private var backgroundColor: Color {
        switch store.viewState {
        case .ready(let snapshot):
            return snapshot.metadata.color
        default:
            return .clear
        }
    }

    public init(
        store: StoreOf<PlotRemixGameFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(metadata: snapshot.metadata)
            case .error(let error):
                Text(verbatim: "\(error.localizedDescription)")
            default:
                EmptyView()
            }
        }
        .frame(maxHeight: .infinity)
        .background {
            backgroundColor
            //            AnimatedMeshBackground(baseColor: backgroundColor)
        }
        .overlay {
            if store.isLoading {
                loadingBody
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(
            store: store.scope(
                state: \.$playGame,
                action: \.playGame
            )
        ) { store in
            PlotRemixGamePlayFeatureView(store: store)
        }
        .task {
            await store.send(.fetch).finish()
        }
    }

}

extension PlotRemixGameView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func content(metadata: GameMetadata) -> some View {
        VStack(spacing: 50) {
            VStack {
                Image(systemName: metadata.iconSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)

                Text(verbatim: metadata.name)
                    .font(.largeTitle)
                    .bold()
            }

            Text(verbatim: metadata.description)

            //            GlassEffectContainer {
            Button {
                store.send(.startGame)
            } label: {
                Label(
                    LocalizedStringResource("START", bundle: .module),
                    systemImage: "play.fill"
                )
                .bold()
                .labelStyle(.iconOnly)
                .padding()
            }
            .buttonStyle(.glassProminent)
            //            }

        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("HIGH_SCORES", systemImage: "list.bullet.rectangle.portrait") {

                }
            }
        }
        .padding()
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity)
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        PlotRemixGameView(
            store: Store(
                initialState: PlotRemixGameFeature.State(
                    gameID: GameMetadata.mock.id,
                    viewState: .ready(.init(metadata: GameMetadata.mock))
                ),
                reducer: {
                    EmptyReducer()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
