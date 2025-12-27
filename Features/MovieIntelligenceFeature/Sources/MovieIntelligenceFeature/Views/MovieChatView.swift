//
//  MovieChatView.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MovieChatView: View {

    @Bindable private var store: StoreOf<MovieIntelligenceFeature>
    @Environment(\.dismiss) private var dismiss

    public init(store: StoreOf<MovieIntelligenceFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        NavigationStack {
            ChatView(
                messages: store.messages,
                send: { prompt in
                    store.send(.sendPrompt(prompt))
                },
                isThinking: store.isThinking
            )
            .navigationTitle(store.movie?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .task {
                store.send(.startSession)
            }
        }
    }

}

#Preview("Messages") {
    NavigationStack {
        MovieChatView(
            store: Store(
                initialState: MovieIntelligenceFeature.State(
                    movieID: 550,
                    messages: Message.mocks
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}
