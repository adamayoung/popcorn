//
//  CreateTVSeriesChatSessionError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Errors that can occur during chat operations
///
public enum CreateTVSeriesChatSessionError: Error {

    /// A tool call failed during the chat session
    case toolCallFailed(Error)

    /// The chat session failed with an error
    case sessionFailed(Error)

    /// Failed to create a chat session
    case sessionCreationFailed(Error? = nil)

}
