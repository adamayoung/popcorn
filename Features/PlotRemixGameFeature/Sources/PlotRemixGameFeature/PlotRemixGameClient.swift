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
import PopcornGamesCatalogAdapters
import PopcornPlotRemixGameAdapters

@DependencyClient
struct PlotRemixGameClient: Sendable {

    var gameMetadata: @Sendable (Int) async throws -> GameMetadata

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
            }
        )
    }

    static var previewValue: PlotRemixGameClient {
        PlotRemixGameClient(
            gameMetadata: { _ in
                try await Task.sleep(for: .seconds(1))
                return GameMetadata.mock
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
