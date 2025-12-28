//
//  CreateTVSeriesIntelligenceSessionUseCase.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

///
/// Use case for creating an intelligence session for a specific TV series
///
public protocol CreateTVSeriesIntelligenceSessionUseCase: Sendable {

    ///
    /// Creates a new intelligence session for the specified TV series.
    ///
    /// - Parameter tvSeriesID: The ID of the TV series to create an intelligence session for.
    ///
    /// - Returns: A new intelligence session instance.
    ///
    /// - Throws: ``CreateTVSeriesIntelligenceSessionError`` if the session cannot be created.
    ///
    func execute(tvSeriesID: Int) async throws(CreateTVSeriesIntelligenceSessionError) -> any LLMSession

}
