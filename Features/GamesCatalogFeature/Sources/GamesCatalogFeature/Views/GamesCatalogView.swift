//
//  GamesCatalogView.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM games catalog view, driven by ``GamesCatalogViewModel``.
public struct GamesCatalogView: View {

    @State private var viewModel: GamesCatalogViewModel
    private let namespace: Namespace.ID

    public init(
        viewModel: GamesCatalogViewModel,
        transitionNamespace: Namespace.ID
    ) {
        _viewModel = State(initialValue: viewModel)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(games: snapshot.games)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("games-catalog.view")
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .navigationTitle(Text("GAMES", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension GamesCatalogView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "gamecontroller",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(games: [GameMetadata]) -> some View {
        LazyVGrid(columns: [.init(), .init()]) {
            ForEach(games) { game in
                Button {
                    viewModel.selectGame(id: game.id)
                } label: {
                    card(for: game)
                }
                .accessibilityLabel(Text(verbatim: game.name))
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
        .foregroundStyle(.white)
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

#if DEBUG
    #Preview("Ready") {
        @Previewable @Namespace var namespace

        NavigationStack {
            GamesCatalogView(
                viewModel: .preview(viewState: .ready(.init(games: GameMetadata.mocks))),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Loading") {
        @Previewable @Namespace var namespace

        NavigationStack {
            GamesCatalogView(
                viewModel: .preview(viewState: .loading),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Error") {
        @Previewable @Namespace var namespace

        NavigationStack {
            GamesCatalogView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchGamesCatalogError.unknown()))),
                transitionNamespace: namespace
            )
        }
    }
#endif
