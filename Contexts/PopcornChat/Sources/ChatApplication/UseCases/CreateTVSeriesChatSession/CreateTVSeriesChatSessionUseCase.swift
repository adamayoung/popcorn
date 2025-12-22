//
//  CreateTVSeriesChatSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation

///
/// Use case for creating a chat session for a specific TV series
///
public protocol CreateTVSeriesChatSessionUseCase: Sendable {

    /// Creates a new chat session for the specified TV series
    ///
    /// - Parameter tvSeriesID: The ID of the TV series to create a chat session for
    ///
    /// - Returns: A new chat session instance
    ///
    func execute(tvSeriesID: Int) async throws(CreateTVSeriesChatSessionError) -> any ChatSessionManaging
}
