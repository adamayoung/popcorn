//
//  CreateMovieIntelligenceSessionUseCase.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

///
/// Use case for creating an intelligence session for a specific movie
///
public protocol CreateMovieIntelligenceSessionUseCase: Sendable {

    ///
    /// Creates a new intelligence session for the specified movie.
    ///
    /// - Parameter movieID: The ID of the movie to create an intelligence session for.
    ///
    /// - Returns: A new intelligence session instance.
    ///
    /// - Throws: ``CreateMovieIntelligenceSessionError`` if the session cannot be created.
    ///
    func execute(movieID: Int) async throws(CreateMovieIntelligenceSessionError) -> any LLMSession

}
