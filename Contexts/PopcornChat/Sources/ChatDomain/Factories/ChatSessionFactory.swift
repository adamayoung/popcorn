//
//  ChatSessionFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

/// Factory protocol for creating chat sessions
public protocol ChatSessionFactory: Sendable {
    /// Creates a new chat session with the provided tools and instructions
    /// - Parameters:
    ///   - tools: An array of tools that the session can use
    ///   - instructions: System instructions for the chat session
    /// - Returns: A new chat session instance
    func makeSession(
        tools: [any Sendable],
        instructions: String
    ) -> any ChatSessionManaging
}
