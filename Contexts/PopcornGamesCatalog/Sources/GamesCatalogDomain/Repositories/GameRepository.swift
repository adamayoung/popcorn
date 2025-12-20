//
//  GameRepository.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

public protocol GameRepository: Sendable {

    func games() async throws(GameRepositoryError) -> [GameMetadata]

    func game(id: Int) async throws(GameRepositoryError) -> GameMetadata

}

public enum GameRepositoryError: Error {
    case notFound
    case unknown(Error? = nil)
}
