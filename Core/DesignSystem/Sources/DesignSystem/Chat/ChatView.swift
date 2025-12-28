//
//  ChatView.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

///
/// A chat interface for displaying messages and sending new ones.
///
/// Provides a complete chat experience with a scrollable message list
/// and a text input field. The view automatically scrolls to the latest
/// message and displays a thinking indicator when the assistant is processing.
///
public struct ChatView<Message: ChatMessage>: View {

    private var messages: [Message]
    private var send: (String) -> Void
    private var isThinking: Bool

    /// Creates a new chat view.
    ///
    /// - Parameters:
    ///   - messages: The array of messages to display in the chat.
    ///   - send: A closure called when the user sends a new message.
    ///   - isThinking: Whether to show the thinking indicator.
    public init(
        messages: [Message],
        send: @escaping (String) -> Void,
        isThinking: Bool
    ) {
        self.messages = messages
        self.send = send
        self.isThinking = isThinking
    }

    public var body: some View {
        ScrollViewReader { proxy in
            List {
                Section {
                    ForEach(messages) { message in
                        MessageRow(message: message)
                            .id(message)
                            .listRowSeparator(.hidden)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .identity
                            ))
                    }
                }

                if isThinking {
                    Section {
                        HStack {
                            AvatarImage(role: .assistant)
                            Text("THINKING", bundle: .module)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .animation(messages.isEmpty ? nil : .spring(response: 0.4, dampingFraction: 0.7), value: messages.count)
            .task(id: messages.count) {
                withAnimation {
                    proxy.scrollTo(messages.last, anchor: .bottom)
                }
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom) {
                ZStack {
                    MessageTextField(
                        isDisabled: isThinking,
                        onSend: send
                    )
                    .padding()
                }
            }
        }
    }
}

#Preview("Not thinking") {
    NavigationStack {
        ChatView<PreviewChatMessage>(
            messages: PreviewChatMessage.mocks,
            send: { _ in },
            isThinking: false
        )
    }
}

#Preview("Thinking") {
    NavigationStack {
        ChatView<PreviewChatMessage>(
            messages: PreviewChatMessage.mocks,
            send: { _ in },
            isThinking: true
        )
    }
}
