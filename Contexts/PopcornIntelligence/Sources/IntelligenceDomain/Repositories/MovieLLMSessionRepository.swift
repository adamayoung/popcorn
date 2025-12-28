//
//  MovieLLMSessionRepository.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A repository protocol for creating and managing movie-focused LLM sessions.
///
/// Conforming types provide the ability to create language model sessions
/// that are configured with context and tools specific to a particular movie,
/// enabling intelligent conversations about that movie's details.
///
public protocol MovieLLMSessionRepository: Sendable {

    ///
    /// Creates a new LLM session configured for a specific movie.
    ///
    /// The session will be initialised with context about the movie and tools
    /// that can fetch additional movie information during the conversation.
    ///
    /// - Parameter movieID: The unique identifier of the movie to create a session for.
    /// - Returns: A configured ``LLMSession`` instance for the specified movie.
    /// - Throws: ``MovieLLMSessionRepositoryError`` if the session cannot be created.
    ///
    func session(
        forMovie movieID: Int
    ) async throws(MovieLLMSessionRepositoryError) -> any LLMSession

}

///
/// Errors that can occur when creating or managing movie LLM sessions.
///
public enum MovieLLMSessionRepositoryError: Error {

    /// The specified movie was not found.
    case movieNotFound

    /// The required tools for the session could not be found or configured.
    case toolsNotFound

    /// An unknown error occurred while creating the session.
    case unknown(Error? = nil)

}
