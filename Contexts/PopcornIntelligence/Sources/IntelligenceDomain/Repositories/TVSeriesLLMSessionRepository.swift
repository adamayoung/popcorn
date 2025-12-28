//
//  TVSeriesLLMSessionRepository.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A repository protocol for creating and managing TV series-focused LLM sessions.
///
/// Conforming types provide the ability to create language model sessions
/// that are configured with context and tools specific to a particular TV series,
/// enabling intelligent conversations about that series' details.
///
public protocol TVSeriesLLMSessionRepository: Sendable {

    ///
    /// Creates a new LLM session configured for a specific TV series.
    ///
    /// The session will be initialised with context about the TV series and tools
    /// that can fetch additional series information during the conversation.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series to create a session for.
    /// - Returns: A configured ``LLMSession`` instance for the specified TV series.
    /// - Throws: ``TVSeriesLLMSessionRepositoryError`` if the session cannot be created.
    ///
    func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession

}

///
/// Errors that can occur when creating or managing TV series LLM sessions.
///
public enum TVSeriesLLMSessionRepositoryError: Error {

    /// The specified TV series was not found.
    case tvSeriesNotFound

    /// The required tools for the session could not be found or configured.
    case toolsNotFound

    /// An unknown error occurred while creating the session.
    case unknown(Error? = nil)

}
