//
//  PlotRemixGameDependencies.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``PlotRemixGameViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``PlotRemixGameViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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
