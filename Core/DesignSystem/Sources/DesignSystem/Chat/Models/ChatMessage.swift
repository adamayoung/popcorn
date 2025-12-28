//
//  ChatMessage.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol defining the requirements for a chat message.
///
/// Conform to this protocol to create message types that can be displayed
/// in the ``ChatView``. Each message has a unique identifier, role, content,
/// and timestamp.
///
public protocol ChatMessage: Identifiable, Sendable, Hashable {

    /// The unique identifier of the message.
    var id: UUID { get }

    /// The role of the message sender (user or assistant).
    var role: ChatRole { get }

    /// The content of the message.
    var content: ChatMessageContent { get }

    /// The timestamp when the message was created.
    var timestamp: Date { get }

}
