//
//  MovieIntelligenceView.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The movie intelligence chat screen, driven by ``MovieIntelligenceViewModel``.
///
/// Wraps ``ChatView`` and provides a navigation title and close button via
/// `@Environment(\.dismiss)`.
public struct MovieIntelligenceView: View {

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
        MovieIntelligenceView(
            viewModel: .preview(messages: Message.mocks)
        )
    }
#endif
