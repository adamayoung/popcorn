//
//  MovieLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

/// Defines the ``MovieLLMSessionRepository`` contract.
public protocol MovieLLMSessionRepository: Sendable {

    func session(
        forMovie movieID: Int
    ) async throws(MovieLLMSessionRepositoryError) -> any LLMSession

}

/// Represents the ``MovieLLMSessionRepositoryError`` values.
public enum MovieLLMSessionRepositoryError: Error {

    case movieNotFound
    case toolsNotFound
    case unknown(Error? = nil)

}
