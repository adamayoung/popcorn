//
//  PlotRemixGamePlayClient.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication
import PlotRemixGameDomain
import PopcornGamesCatalogAdapters
import PopcornPlotRemixGameAdapters

@DependencyClient
struct PlotRemixGamePlayClient: Sendable {

    var generateGame: @Sendable (@Sendable @escaping (Float) -> Void) async throws -> Game

}

extension PlotRemixGamePlayClient: DependencyKey {

    static var liveValue: PlotRemixGamePlayClient {
        @Dependency(\.fetchGame) var fetchGame
        @Dependency(\.generatePlotRemixGame) var generatePlotRemixGame

        return PlotRemixGamePlayClient(
            generateGame: { progress in
                let config = GameConfig(theme: .darkCryptic)
                let game = try await generatePlotRemixGame.execute(
                    config: config,
                    progress: progress
                )
                let mapper = GameMapper()

                return mapper.map(game)
            }
        )
    }

    static var previewValue: PlotRemixGamePlayClient {
        PlotRemixGamePlayClient(
            generateGame: { _ in
                Game(
                    id: UUID(),
                    questions: []
                )
            }
        )
    }

}

extension DependencyValues {

    var plotRemixGamePlayClient: PlotRemixGamePlayClient {
        get { self[PlotRemixGamePlayClient.self] }
        set { self[PlotRemixGamePlayClient.self] = newValue }
    }

}
