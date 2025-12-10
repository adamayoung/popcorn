//
//  GamesCatalogClient.swift
//  GamesCatalogFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication
import GamesCatalogDomain
import PopcornGamesCatalogAdapters

struct GamesCatalogClient: Sendable {

    var fetchGames: @Sendable () async throws -> [GameMetadata]

}

extension GamesCatalogClient: DependencyKey {

    static var liveValue: GamesCatalogClient {
        let factory = GamesCatalogClientFactory()

        return GamesCatalogClient(
            fetchGames: {
                let useCase = factory.makeFetchGames()
                let games = try await useCase.execute()
                let mapper = GameMetadataMapper()
                return games.map(mapper.map)
            }
        )
    }

    static var previewValue: GamesCatalogClient {
        GamesCatalogClient(
            fetchGames: {
                try await Task.sleep(for: .seconds(1))
                return GameMetadata.mocks
            }
        )
    }

}

extension DependencyValues {

    var gamesCatalog: GamesCatalogClient {
        get {
            self[GamesCatalogClient.self]
        }
        set {
            self[GamesCatalogClient.self] = newValue
        }
    }

}
