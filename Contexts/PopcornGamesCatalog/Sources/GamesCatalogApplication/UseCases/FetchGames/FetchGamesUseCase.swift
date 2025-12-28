//
//  FetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

///
/// A use case for fetching all available games from the catalog.
///
/// This protocol defines the application-layer interface for retrieving
/// the complete list of games available in the catalog.
///
public protocol FetchGamesUseCase: Sendable {

    ///
    /// Fetches all available games from the catalog.
    ///
    /// - Returns: An array of ``GameMetadata`` representing all available games.
    /// - Throws: ``FetchGamesError`` if the fetch operation fails.
    ///
    func execute() async throws(FetchGamesError) -> [GameMetadata]

}
