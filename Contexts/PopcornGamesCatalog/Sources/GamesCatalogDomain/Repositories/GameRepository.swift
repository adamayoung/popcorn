//
//  GameRepository.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

public protocol GameRepository: Sendable {

    func games(cachePolicy: CachePolicy) async throws(GameRepositoryError) -> [GameMetadata]

    func game(
        id: Int,
        cachePolicy: CachePolicy
    ) async throws(GameRepositoryError) -> GameMetadata

}

extension GameRepository {

    public func games() async throws(GameRepositoryError) -> [GameMetadata] {
        try await games(cachePolicy: .cacheFirst)
    }

    public func game(id: Int) async throws(GameRepositoryError) -> GameMetadata {
        try await game(id: id, cachePolicy: .cacheFirst)
    }

}

public enum GameRepositoryError: Error {
    case cacheUnavailable
    case notFound
    case unknown(Error? = nil)
}
