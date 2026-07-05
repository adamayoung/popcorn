//
//  PlotRemixGameDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import GamesCatalogApplication
import GamesCatalogComposition
import PlotRemixGameApplication
import PlotRemixGameComposition
import PlotRemixGameDomain
import PlotRemixGameFeature

extension PlotRemixGameDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Wires the fetch-game and generate-game use cases with their mappers and
    /// the default game configuration.
    static func live(services: AppServices) -> PlotRemixGameDependencies {
        let fetchGame = services.gamesCatalogFactory.makeFetchGameUseCase()
        let generatePlotRemixGame = services.plotRemixGameFactory.makeGeneratePlotRemixGameUseCase()

        return PlotRemixGameDependencies(
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

}
