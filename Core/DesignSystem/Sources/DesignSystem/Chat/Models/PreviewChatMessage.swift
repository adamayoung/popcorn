//
//  PreviewChatMessage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct PreviewChatMessage: ChatMessage {

    let id: UUID
    let role: ChatRole
    let content: ChatMessageContent
    let timestamp: Date

    init(
        id: UUID = UUID(),
        role: ChatRole,
        content: ChatMessageContent,
        timestamp: Date = .now
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }

}

extension PreviewChatMessage {

    static var mocks: [PreviewChatMessage] {
        [
            PreviewChatMessage(
                role: .user,
                content: .text("Tell me about this movie."),
                timestamp: Date(timeIntervalSince1970: 0)
            ),
            PreviewChatMessage(
                role: .assistant,
                content: .text("This movie is titled 'Fight Club'."),
                timestamp: Date(timeIntervalSince1970: 5)
            )
        ]
    }

}
