//
//  UITestPopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameApplication
import PlotRemixGameComposition
import PlotRemixGameDomain

public final class UITestPopcornPlotRemixGameFactory: PopcornPlotRemixGameFactory {

    private let applicationFactory: PlotRemixGameApplicationFactory

    public init() {
        self.applicationFactory = PlotRemixGameApplicationFactory(
            appConfigurationProvider: StubAppConfigurationProvider(),
            movieProvider: StubMovieProvider(),
            genreProvider: StubGenreProvider(),
            synopsisRiddleGenerator: StubSynopsisRiddleGenerator()
        )
    }

    public func makeGeneratePlotRemixGameUseCase() -> GeneratePlotRemixGameUseCase {
        applicationFactory.makeGeneratePlotRemixGameUseCase()
    }

}
