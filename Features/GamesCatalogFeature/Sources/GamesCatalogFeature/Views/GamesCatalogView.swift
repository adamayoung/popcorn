//
//  GamesCatalogView.swift
//  GamesCatalogFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

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
            LazyVGrid(columns: [.init(), .init()]) {
                if let games = store.games {
                    ForEach(games) { game in
                        Button {
                            store.send(.navigate(.game(id: game.id)))
                        } label: {
                            card(for: game)
                        }
                        .matchedTransitionSource(id: game.id, in: namespace)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text("GAMES", bundle: .module))
        .task { store.send(.loadGames) }
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
                startPoint: .topLeading,  // Top-Left
                endPoint: .bottomTrailing  // Bottom-Right
            )
        }
        .background(game.color)
        .clipShape(.rect(cornerRadius: 15))
    }

}

#Preview {
    @Previewable @Namespace var namespace

    NavigationStack {
        GamesCatalogView(
            store: Store(
                initialState: GamesCatalogFeature.State(),
                reducer: {
                    GamesCatalogFeature()
                }
            ),
            transitionNamespace: namespace
        )
    }

}
