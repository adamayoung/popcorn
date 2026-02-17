//
//  Message.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Foundation
import SwiftUI

public struct Message: ChatMessage {

    public let id: UUID
    public let role: ChatRole
    public let content: ChatMessageContent
    public let timestamp: Date

    public init(
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

    public init(
        id: UUID = UUID(),
        role: ChatRole,
        textContent: String,
        timestamp: Date = .now
    ) {
        self.init(
            id: id,
            role: role,
            content: .text(textContent),
            timestamp: timestamp
        )
    }

}

extension Message {

    static var mocks: [Message] {
        [
            Message(role: .user, textContent: "Tell me about this movie."),
            Message(role: .assistant, textContent: "This movie is titled 'Fight Club'.")
        ]
    }

}
