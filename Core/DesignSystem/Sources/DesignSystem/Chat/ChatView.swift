//
//  ChatView.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct ChatView<Message: ChatMessage>: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var messages: [Message]
    private var send: (String) -> Void
    private var isThinking: Bool

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
                            .transition(reduceMotion
                                ? .opacity
                                : .asymmetric(
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
                        .accessibilityElement(children: .combine)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .animation(
                reduceMotion ? nil : (messages.isEmpty ? nil : .spring(response: 0.4, dampingFraction: 0.7)),
                value: messages.count
            )
            .task(id: messages.count) {
                if reduceMotion {
                    proxy.scrollTo(messages.last, anchor: .bottom)
                } else {
                    withAnimation {
                        proxy.scrollTo(messages.last, anchor: .bottom)
                    }
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
