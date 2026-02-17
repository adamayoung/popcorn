//
//  TVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Defines the ``TVSeriesLLMSessionRepository`` contract.
public protocol TVSeriesLLMSessionRepository: Sendable {

    func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession

}

/// Represents the ``TVSeriesLLMSessionRepositoryError`` values.
public enum TVSeriesLLMSessionRepositoryError: Error {

    case tvSeriesNotFound
    case toolsNotFound
    case unknown(Error? = nil)

}
