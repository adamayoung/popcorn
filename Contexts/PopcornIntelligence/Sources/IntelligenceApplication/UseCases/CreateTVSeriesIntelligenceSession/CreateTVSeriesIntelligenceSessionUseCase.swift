//
//  CreateTVSeriesIntelligenceSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

///
/// Use case for creating an intelligence session for a specific TV series
///
/// Defines the ``CreateTVSeriesIntelligenceSessionUseCase`` contract.
public protocol CreateTVSeriesIntelligenceSessionUseCase: Sendable {

    ///
    /// Creates a new intelligence session for the specified TV series
    ///
    /// - Parameter tvSeriesID: The ID of the TV series to create an intelligence session for
    ///
    /// - Returns: A new intelligence session instance
    ///
    func execute(tvSeriesID: Int) async throws(CreateTVSeriesIntelligenceSessionError) -> any LLMSession

}
