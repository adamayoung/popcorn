//
//  MovieChatToolsProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Protocol for providing chat tools related to a specific movie
/// 
public protocol MovieChatToolsProviding: Sendable {

    ///
    /// Returns an array of tools that can be used in a movie chat session
    ///
    /// - Parameter movieID: The ID of the movie to provide tools for
    ///
    /// - Returns: An array of tools conforming to the FoundationModels Tool protocol
    ///
    func tools(for movieID: Int) -> [any Sendable]
}
