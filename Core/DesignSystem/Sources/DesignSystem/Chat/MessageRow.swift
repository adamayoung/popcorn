//
//  MessageRow.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct MessageRow: View {

    public var message: any ChatMessage

    public init(message: any ChatMessage) {
        self.message = message
    }

    public var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }

            VStack(
                alignment: message.role == .user ? .trailing : .leading,
                spacing: .spacing10
            ) {
                HStack(alignment: .bottom, spacing: .spacing4) {
                    if message.role == .assistant {
                        AvatarImage(role: message.role)
                    }

                    messageContent(message.content, role: message.role)

                    if message.role == .user {
                        AvatarImage(role: message.role)
                    }
                }
            }
            .padding(.leading, message.role == .user ? .spacing40 : 0)
            .padding(.trailing, message.role == .assistant ? .spacing40 : 0)

            if message.role == .assistant {
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(message.role == .user ? "YOU" : "ASSISTANT", bundle: .module))
    }

    private func messageContent(_ content: ChatMessageContent, role: ChatRole) -> some View {
        switch content {
        case .text(let textContent):
            Text(verbatim: textContent)
                .foregroundStyle(role.textColor)
                .padding(.vertical, .spacing10)
                .padding(.horizontal, .spacing15)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(message.role.bubbleColour)
                }
        }
    }

}

#Preview {
    List {
        ForEach(PreviewChatMessage.mocks) { message in
            MessageRow(message: message)
                .id(message.id)
                .listRowSeparator(.hidden)
        }
    }
    .listStyle(.plain)
}
