//
//  DefaultFetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

final class DefaultFetchGamesUseCase: FetchGamesUseCase {

    private let repository: any GameRepository

    init(repository: some GameRepository) {
        self.repository = repository
    }

    func execute() async throws(FetchGamesError) -> [GameMetadata] {
        let games: [GameMetadata]
        do {
            games = try await repository.games()
        } catch let error {
            throw FetchGamesError(error)
        }

        return games
    }

}
