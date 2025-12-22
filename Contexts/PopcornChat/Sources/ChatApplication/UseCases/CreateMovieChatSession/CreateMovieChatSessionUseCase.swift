//
//  CreateMovieChatSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation

///
/// Use case for creating a chat session for a specific movie
///
public protocol CreateMovieChatSessionUseCase: Sendable {

    ///
    /// Creates a new chat session for the specified movie
    ///
    /// - Parameter movieID: The ID of the movie to create a chat session for
    ///
    /// - Returns: A new chat session instance
    ///
    func execute(movieID: Int) async throws(CreateMovieChatSessionError) -> any ChatSessionManaging

}
