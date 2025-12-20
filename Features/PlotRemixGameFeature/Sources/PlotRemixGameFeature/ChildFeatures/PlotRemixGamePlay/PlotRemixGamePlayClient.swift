//
//  PlotRemixGamePlayClient.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
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
