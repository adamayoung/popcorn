//
//  PlotRemixGameDependencies.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import GamesCatalogApplication
import PlotRemixGameDomain

/// The dependencies required by ``PlotRemixGameViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``PlotRemixGameViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct PlotRemixGameDependencies: Sendable {

    public var gameMetadata: @Sendable (_ id: Int) async throws -> GameMetadata
    public var generateGame: @Sendable (_ progress: @Sendable @escaping (Float) -> Void) async throws -> Game

    public init(
        gameMetadata: @escaping @Sendable (_ id: Int) async throws -> GameMetadata,
        generateGame: @escaping @Sendable (_ progress: @Sendable @escaping (Float) -> Void) async throws -> Game
    ) {
        self.gameMetadata = gameMetadata
        self.generateGame = generateGame
    }

}

public extension PlotRemixGameDependencies {

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

#if DEBUG
    public extension PlotRemixGameDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: PlotRemixGameDependencies {
            PlotRemixGameDependencies(
                gameMetadata: { _ in GameMetadata.mock },
                generateGame: { _ in Game.mock }
            )
        }

    }
#endif
