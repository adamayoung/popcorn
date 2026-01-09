//
//  PopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameApplication

public protocol PopcornPlotRemixGameFactory: Sendable {

    func makeGeneratePlotRemixGameUseCase() -> GeneratePlotRemixGameUseCase

}
