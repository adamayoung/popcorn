//
//  MessageRow.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

///
/// A row component that displays a single chat message.
///
/// Renders a message with an avatar and styled bubble. User messages
/// appear on the right with a blue bubble, while assistant messages
/// appear on the left with a gray bubble.
///
public struct MessageRow: View {

    /// The message to display.
    public var message: any ChatMessage

    /// Creates a new message row.
    ///
    /// - Parameter message: The chat message to display.
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
                spacing: 10
            ) {
                HStack(alignment: .bottom, spacing: 4) {
                    if message.role == .assistant {
                        AvatarImage(role: message.role)
                    }

                    messageContent(message.content, role: message.role)

                    if message.role == .user {
                        AvatarImage(role: message.role)
                    }
                }
            }
            .padding(.leading, message.role == .user ? 40 : 0)
            .padding(.trailing, message.role == .assistant ? 40 : 0)

            if message.role == .assistant {
                Spacer()
            }
        }
    }

    private func messageContent(_ content: ChatMessageContent, role: ChatRole) -> some View {
        switch content {
        case .text(let textContent):
            Text(verbatim: textContent)
                .foregroundStyle(role.textColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
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
