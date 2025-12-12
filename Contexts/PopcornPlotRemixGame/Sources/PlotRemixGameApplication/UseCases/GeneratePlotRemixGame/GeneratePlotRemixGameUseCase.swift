//
//  GeneratePlotRemixGameUseCase.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import PlotRemixGameDomain

public protocol GeneratePlotRemixGameUseCase: Sendable {

    func execute(
        config: GameConfig,
        progress: @Sendable @escaping (Float) -> Void
    ) async throws(GeneratePlotRemixGameError) -> Game

}
