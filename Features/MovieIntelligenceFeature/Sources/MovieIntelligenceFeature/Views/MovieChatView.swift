//
//  MovieChatView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MovieChatView: View {

    @Bindable private var store: StoreOf<MovieIntelligenceFeature>

    public init(store: StoreOf<MovieIntelligenceFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(store.messages) { message in
                    MessageRow(message: message)
                        .id(message)
                        .listRowSeparator(.hidden)
                }
                .scrollDismissesKeyboard(.interactively)
                .task(id: store.messages) {
                    withAnimation {
                        proxy.scrollTo(store.messages.last, anchor: .bottom)
                    }
                }
                .listStyle(.plain)
                .safeAreaInset(edge: .bottom) {
                    ZStack {
                        MessageTextField(
                            isDisabled: false,
                            onSend: sendMessage
                        )
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) {
                        store.send(.close)
                    }
                }
            }
            .task {
                store.send(.startSession)
            }
        }
    }

    private func sendMessage(text: String) {
        store.send(.sendPrompt(text))
    }

}

#Preview("Messages") {
    NavigationStack {
        MovieChatView(
            store: Store(
                initialState: MovieIntelligenceFeature.State(
                    movieID: 550,
                    messages: [
                        Message(author: .user, content: "Tell me about this movie."),
                        Message(author: .bot, content: "This movie is titled 'Fight Club'.")
                    ]
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}
