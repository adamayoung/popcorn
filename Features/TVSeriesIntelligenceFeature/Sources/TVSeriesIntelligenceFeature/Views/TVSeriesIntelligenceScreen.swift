//
//  TVSeriesIntelligenceScreen.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM TV series intelligence chat screen, driven by
/// ``TVSeriesIntelligenceViewModel``.
///
/// Renders the same store-free ``ChatView`` and reproduces the exact navigation
/// chrome of the former `TVSeriesChatView`, so recorded snapshots stay identical.
/// Dismissal stays view-level via `@Environment(\.dismiss)`.
public struct TVSeriesIntelligenceScreen: View {

    @State private var viewModel: TVSeriesIntelligenceViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: TVSeriesIntelligenceViewModel) {
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
            .navigationTitle(viewModel.tvSeriesName ?? "")
            #if !os(visionOS)
                .navigationSubtitle(viewModel.tvSeriesTagline ?? "")
            #endif
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
        TVSeriesIntelligenceScreen(
            viewModel: .preview(messages: Message.mocks)
        )
    }
#endif
