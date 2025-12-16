//
//  DefaultFetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
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
