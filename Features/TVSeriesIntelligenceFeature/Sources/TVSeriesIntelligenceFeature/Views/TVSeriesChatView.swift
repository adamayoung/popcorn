//
//  TVSeriesChatView.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TVSeriesChatView: View {

    @Bindable private var store: StoreOf<TVSeriesIntelligenceFeature>

    public init(store: StoreOf<TVSeriesIntelligenceFeature>) {
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

}

#Preview("Messages") {
    NavigationStack {
        TVSeriesChatView(
            store: Store(
                initialState: TVSeriesIntelligenceFeature.State(
                    tvSeriesID: 1396,
                    messages: Message.mocks
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}
