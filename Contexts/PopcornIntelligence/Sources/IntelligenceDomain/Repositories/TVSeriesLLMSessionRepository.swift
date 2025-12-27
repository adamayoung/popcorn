//
//  TVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol TVSeriesLLMSessionRepository: Sendable {

    func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession

}

public enum TVSeriesLLMSessionRepositoryError: Error {

    case tvSeriesNotFound
    case toolsNotFound
    case unknown(Error? = nil)

}
