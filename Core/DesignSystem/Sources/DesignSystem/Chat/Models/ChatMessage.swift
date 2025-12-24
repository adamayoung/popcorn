//
//  ChatMessage.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol ChatMessage: Identifiable, Sendable, Hashable {

    var id: UUID { get }
    var role: ChatRole { get }
    var content: ChatMessageContent { get }
    var timestamp: Date { get }

}
