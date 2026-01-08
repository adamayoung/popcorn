//
//  MockGameRepository.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

final class MockGameRepository: GameRepository, @unchecked Sendable {

    var gamesCallCount = 0
    var gamesStub: Result<[GameMetadata], GameRepositoryError>?

    func games() async throws(GameRepositoryError) -> [GameMetadata] {
        gamesCallCount += 1

        guard let stub = gamesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let games):
            return games
        case .failure(let error):
            throw error
        }
    }

    var gameCallCount = 0
    var gameCalledWith: [Int] = []
    var gameStub: Result<GameMetadata, GameRepositoryError>?

    func game(id: Int) async throws(GameRepositoryError) -> GameMetadata {
        gameCallCount += 1
        gameCalledWith.append(id)

        guard let stub = gameStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let game):
            return game
        case .failure(let error):
            throw error
        }
    }

}
