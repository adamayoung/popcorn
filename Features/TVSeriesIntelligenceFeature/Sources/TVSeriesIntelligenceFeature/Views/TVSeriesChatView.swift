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
    @Environment(\.dismiss) private var dismiss

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
            .navigationTitle(store.tvSeries?.name ?? "")
            .navigationSubtitle(store.tvSeries?.tagline ?? "")
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
