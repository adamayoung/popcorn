//
//  ChatSessionManaging.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Protocol defining the behavior of a chat session
///
public protocol ChatSessionManaging: Sendable {

    /// Send a message to the chat session and receive a response
    ///
    /// - Parameter message: The message to send
    /// - Returns: The response from the chat session
    ///
    /// - Throws: ChatError if the message fails to send or receive a response
    ///
    func send(message: String) async throws(ChatSessionManagerError) -> String

}

///
/// Errors that can occur during chat operations
///
public enum ChatSessionManagerError: Error {

    /// A tool call failed during the chat session
    case toolCallFailed(Error)

    /// The chat session failed with an error
    case sessionFailed(Error)

    /// Failed to create a chat session
    case sessionCreationFailed(Error? = nil)

}
