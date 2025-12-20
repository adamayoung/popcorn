//
//  DefaultFetchGameUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

final class DefaultFetchGameUseCase: FetchGameUseCase {

    private let repository: any GameRepository

    init(repository: some GameRepository) {
        self.repository = repository
    }

    func execute(id: GameMetadata.ID) async throws(FetchGameError) -> GameMetadata {
        let game: GameMetadata
        do {
            game = try await repository.game(id: id)
        } catch let error {
            throw FetchGameError(error)
        }

        return game
    }

}
