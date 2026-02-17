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

public extension Message {

    /// `id` and `timestamp` are auto-generated identity metadata and are excluded from equality
    /// so that TCA state assertions can match messages by role and content without caring about
    /// the specific UUID or creation time. SwiftUI view identity uses `Identifiable.id`, not `==`.
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.role == rhs.role && lhs.content == rhs.content
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(role)
        hasher.combine(content)
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
