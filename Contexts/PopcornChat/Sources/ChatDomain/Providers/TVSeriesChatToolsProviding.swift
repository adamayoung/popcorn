//
//  TVSeriesChatToolsProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

/// Protocol for providing chat tools related to a specific TV series
public protocol TVSeriesChatToolsProviding: Sendable {
    /// Returns an array of tools that can be used in a TV series chat session
    /// - Parameter tvSeriesID: The ID of the TV series to provide tools for
    /// - Returns: An array of tools conforming to the FoundationModels Tool protocol
    func tools(for tvSeriesID: Int) -> [any Sendable]
}
