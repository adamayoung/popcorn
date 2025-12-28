//
//  GameRepository.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

///
/// A repository for fetching game metadata from the games catalog.
///
/// This protocol defines the data access layer for retrieving game information,
/// supporting various caching strategies through the ``CachePolicy`` parameter.
///
public protocol GameRepository: Sendable {

    ///
    /// Fetches all available games from the catalog.
    ///
    /// - Parameter cachePolicy: The caching strategy to use for this fetch operation.
    /// - Returns: An array of ``GameMetadata`` representing all available games.
    /// - Throws: ``GameRepositoryError`` if the fetch operation fails.
    ///
    func games(cachePolicy: CachePolicy) async throws(GameRepositoryError) -> [GameMetadata]

    ///
    /// Fetches a specific game by its identifier.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the game to fetch.
    ///   - cachePolicy: The caching strategy to use for this fetch operation.
    /// - Returns: The ``GameMetadata`` for the requested game.
    /// - Throws: ``GameRepositoryError.notFound`` if no game exists with the given identifier.
    ///
    func game(
        id: Int,
        cachePolicy: CachePolicy
    ) async throws(GameRepositoryError) -> GameMetadata

}

public extension GameRepository {

    ///
    /// Fetches all available games using the default cache-first policy.
    ///
    /// - Returns: An array of ``GameMetadata`` representing all available games.
    /// - Throws: ``GameRepositoryError`` if the fetch operation fails.
    ///
    func games() async throws(GameRepositoryError) -> [GameMetadata] {
        try await games(cachePolicy: .cacheFirst)
    }

    ///
    /// Fetches a specific game by its identifier using the default cache-first policy.
    ///
    /// - Parameter id: The unique identifier of the game to fetch.
    /// - Returns: The ``GameMetadata`` for the requested game.
    /// - Throws: ``GameRepositoryError.notFound`` if no game exists with the given identifier.
    ///
    func game(id: Int) async throws(GameRepositoryError) -> GameMetadata {
        try await game(id: id, cachePolicy: .cacheFirst)
    }

}

///
/// Errors that can occur during game repository operations.
///
/// These errors represent the various failure modes when fetching game data
/// from the repository, including cache and network-related failures.
///
public enum GameRepositoryError: Error {

    /// The cache is unavailable and cannot be accessed.
    case cacheUnavailable

    /// The requested game was not found in the repository.
    case notFound

    /// An unknown error occurred during the repository operation.
    case unknown(Error? = nil)

}
