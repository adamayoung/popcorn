//
//  GeneratePlotRemixGameUseCase.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

public protocol GeneratePlotRemixGameUseCase: Sendable {

    func execute(
        config: GameConfig,
        progress: @Sendable @escaping (Float) -> Void
    ) async throws(GeneratePlotRemixGameError) -> Game

}
