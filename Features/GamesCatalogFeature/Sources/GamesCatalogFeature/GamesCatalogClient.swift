//
//  GamesCatalogClient.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import GamesCatalogApplication
import GamesCatalogDomain

@DependencyClient
struct GamesCatalogClient: Sendable {

    var fetchGames: @Sendable () async throws -> [GameMetadata]

}

extension GamesCatalogClient: DependencyKey {

    static var liveValue: GamesCatalogClient {
        @Dependency(\.fetchGames) var fetchGames

        return GamesCatalogClient(
            fetchGames: {
                do {
                    let games = try await fetchGames.execute()
                    let mapper = GameMetadataMapper()
                    return games.map(mapper.map)
                } catch let error as FetchGamesError {
                    throw FetchGamesCatalogError(error)
                }
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

    var gamesCatalogClient: GamesCatalogClient {
        get {
            self[GamesCatalogClient.self]
        }
        set {
            self[GamesCatalogClient.self] = newValue
        }
    }

}
