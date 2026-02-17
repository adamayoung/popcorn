//
//  PopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameApplication

public protocol PopcornPlotRemixGameFactory: Sendable {

    func makeGeneratePlotRemixGameUseCase() -> GeneratePlotRemixGameUseCase

}
