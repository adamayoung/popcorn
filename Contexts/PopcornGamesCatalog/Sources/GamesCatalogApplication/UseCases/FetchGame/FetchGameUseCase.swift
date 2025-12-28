//
//  FetchGameUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

///
/// A use case for fetching a single game from the catalog.
///
/// This protocol defines the application-layer interface for retrieving
/// game metadata by its identifier.
///
public protocol FetchGameUseCase: Sendable {

    ///
    /// Fetches a game by its identifier.
    ///
    /// - Parameter id: The unique identifier of the game to fetch.
    /// - Returns: The ``GameMetadata`` for the requested game.
    /// - Throws: ``FetchGameError.notFound`` if no game exists with the given identifier.
    ///
    func execute(id: GameMetadata.ID) async throws(FetchGameError) -> GameMetadata

}
