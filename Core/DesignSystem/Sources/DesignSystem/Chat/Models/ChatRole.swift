//
//  ChatRole.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftUI

///
/// The role of a participant in a chat conversation.
///
/// Determines the visual styling and positioning of messages in the chat view.
/// User messages appear on the right with a blue bubble, while assistant
/// messages appear on the left with a gray bubble.
///
public enum ChatRole: Sendable, Hashable {

    /// The human user sending messages.
    case user

    /// The AI assistant responding to messages.
    case assistant

}

extension ChatRole {

    var textColor: Color {
        switch self {
        case .user: .white
        case .assistant: .primary
        }
    }

    var bubbleColour: Color {
        switch self {
        case .user: .blue
        case .assistant: .gray.opacity(0.1)
        }
    }

    var avatarSymbol: String {
        switch self {
        case .user: "person.fill"
        case .assistant: "apple.intelligence"
        }
    }

    var avatarSymbolColor: Color {
        switch self {
        case .user: .primary
        case .assistant: .yellow
        }
    }

}
