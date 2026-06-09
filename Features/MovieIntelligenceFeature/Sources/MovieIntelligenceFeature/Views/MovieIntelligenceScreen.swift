//
//  MovieIntelligenceScreen.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM movie intelligence chat screen, driven by ``MovieIntelligenceViewModel``.
///
/// Reuses the same store-free ``ChatView`` chrome as the former `MovieChatView`,
/// keeping `@Environment(\.dismiss)` for the close button exactly as before.
public struct MovieIntelligenceScreen: View {

    @State private var viewModel: MovieIntelligenceViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: MovieIntelligenceViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ChatView(
                messages: viewModel.messages,
                send: { prompt in
                    Task { await viewModel.sendPrompt(prompt) }
                },
                isThinking: viewModel.isThinking
            )
            .navigationTitle(viewModel.movieTitle ?? "")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    ToolbarItem {
                        Button(role: .close) {
                            dismiss()
                        }
                    }
                }
                .task {
                    await viewModel.startSession()
                }
        }
    }

}

#if DEBUG
    #Preview("Messages") {
        MovieIntelligenceScreen(
            viewModel: .preview(messages: Message.mocks)
        )
    }
#endif
