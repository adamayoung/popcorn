//
//  GamesCatalogView.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct GamesCatalogView: View {

    @Bindable var store: StoreOf<GamesCatalogFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<GamesCatalogFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            switch store.viewState {
            case .ready(let snapshot):
                content(games: snapshot.games)
            case .error(let error):
                ContentUnavailableView {
                    Label("UNABLE_TO_LOAD", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button("RETRY") {
                            store.send(.fetch)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            default:
                EmptyView()
            }
        }
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .navigationTitle(Text("GAMES", bundle: .module))
        .task { store.send(.fetch) }
    }

}

extension GamesCatalogView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func content(games: [GameMetadata]) -> some View {
        LazyVGrid(columns: [.init(), .init()]) {
            ForEach(games) { game in
                Button {
                    store.send(.navigate(.game(id: game.id)))
                } label: {
                    card(for: game)
                }
                .matchedTransitionSource(id: game.id, in: namespace)
            }
        }
        .padding()
    }

    private func card(for game: GameMetadata) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: game.iconSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            Spacer()
            Text(verbatim: game.name)
                .font(.headline)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background {
            LinearGradient(
                colors: [Color.white.opacity(0.3), Color.clear],
                startPoint: .topLeading, // Top-Left
                endPoint: .bottomTrailing // Bottom-Right
            )
        }
        .background(game.color)
        .clipShape(.rect(cornerRadius: 15))
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        GamesCatalogView(
            store: Store(
                initialState: GamesCatalogFeature.State(
                    viewState: .ready(
                        .init(games: GameMetadata.mocks)
                    )
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        GamesCatalogView(
            store: Store(
                initialState: GamesCatalogFeature.State(
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
