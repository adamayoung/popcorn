//
//  TVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol TVSeriesLLMSessionRepository {

    func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession

}

public enum TVSeriesLLMSessionRepositoryError: Error {

    case toolsNotFound
    case unknown(Error? = nil)

}
