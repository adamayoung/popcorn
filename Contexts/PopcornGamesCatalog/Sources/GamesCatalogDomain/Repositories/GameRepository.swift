//
//  GameRepository.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

public protocol GameRepository: Sendable {

    func games() async throws(GameRepositoryError) -> [GameMetadata]

    func game(id: Int) async throws(GameRepositoryError) -> GameMetadata

}

public enum GameRepositoryError: Error {
    case notFound
    case unknown(Error? = nil)
}
