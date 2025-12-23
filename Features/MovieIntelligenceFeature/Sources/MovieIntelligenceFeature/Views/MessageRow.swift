//
//  MessageRow.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

struct MessageRow: View {

    var message: Message

    var body: some View {
        HStack {
            if message.author == .user {
                Spacer()
            }

            VStack(
                alignment: message.author == .user ? .trailing : .leading,
                spacing: 10
            ) {
                HStack(alignment: .bottom, spacing: 4) {
                    if message.author == .bot {
                        avatarView(for: message.author)
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.blue, .red, .green)
                    }

                    Text(message.localizedText)
                        .foregroundStyle(message.author.textColor)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(message.author.bubbleColour)
                        }

                    if message.author == .user {
                        avatarView(for: message.author)
                    }
                }
            }
            .padding(.leading, message.author == .user ? 40 : 0)
            .padding(.trailing, message.author == .bot ? 40 : 0)

            if message.author == .bot {
                Spacer()
            }
        }
    }

    private func avatarView(for author: Author) -> some View {
        Image(systemName: author.avatarSymbol)
            .foregroundStyle(author.avatarSymbolColor)
            .padding(5)
            .background(
                Circle().fill(author.bubbleColour.opacity(0.4))
            )
    }

}

extension Author {

    var textColor: Color {
        switch self {
        case .user: .white
        case .bot: .primary
        }
    }

    var bubbleColour: Color {
        switch self {
        case .user: .blue // Color("UserMessageBubble", bundle: .module)
        case .bot: .gray.opacity(0.1) // Color("BotMessageBubble", bundle: .module)
        }
    }

    var avatarSymbol: String {
        switch self {
        case .user: "person.fill"
        case .bot: "apple.intelligence"
        }
    }

    var avatarSymbolColor: Color {
        switch self {
        case .user: .primary
        case .bot: .yellow
        }
    }

}

#Preview {
    let messages: [Message] = [
        Message(author: .user, content: "Tell me about this movie."),
        Message(author: .bot, content: "This movie is titled 'Fight Club'.")
    ]

    List {
        ForEach(messages) { message in
            MessageRow(message: message)
                .id(message.id)
                .listRowSeparator(.hidden)
        }
    }
    .listStyle(.plain)
}
