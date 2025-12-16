//
//  PlotRemixGameClient.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication
import PlotRemixGameDomain

@DependencyClient
struct PlotRemixGameClient: Sendable {

    var gameMetadata: @Sendable (Int) async throws -> GameMetadata
    var generateGame: @Sendable (@Sendable @escaping (Float) -> Void) async throws -> Game

}

extension PlotRemixGameClient: DependencyKey {

    static var liveValue: PlotRemixGameClient {
        @Dependency(\.fetchGame) var fetchGame
        @Dependency(\.generatePlotRemixGame) var generatePlotRemixGame

        return PlotRemixGameClient(
            gameMetadata: { id in
                let gameMetadata = try await fetchGame.execute(id: id)
                let mapper = GameMetadataMapper()
                return mapper.map(gameMetadata)
            },
            generateGame: { progress in
                let config = GameConfig(
                    theme: .child,
                    genreID: 10751,
                    primaryReleaseYearFilter: .betweenYears(start: 2015, end: 2025)
                )
                let game = try await generatePlotRemixGame.execute(
                    config: config,
                    progress: progress
                )
                let mapper = GameMapper()

                return mapper.map(game)
            }
        )
    }

    static var previewValue: PlotRemixGameClient {
        PlotRemixGameClient(
            gameMetadata: { _ in
                try await Task.sleep(for: .seconds(1))
                return GameMetadata.mock
            },
            generateGame: { _ in
                try await Task.sleep(for: .seconds(1))
                return Game.mock
            }
        )
    }

}

extension DependencyValues {

    var plotRemixGameClient: PlotRemixGameClient {
        get { self[PlotRemixGameClient.self] }
        set { self[PlotRemixGameClient.self] = newValue }
    }

}
