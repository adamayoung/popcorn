//
//  LivePopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import PlotRemixGameApplication
import PlotRemixGameDomain
import PlotRemixGameInfrastructure

public final class LivePopcornPlotRemixGameFactory: PopcornPlotRemixGameFactory {

    private let applicationFactory: PlotRemixGameApplicationFactory

    public init(
        appConfigurationProvider: some AppConfigurationProviding,
        movieProvider: some MovieProviding,
        genreProvider: some GenreProviding,
        observability: some Observing
    ) {
        let infrastructureFactory = PlotRemixGameInfrastructureFactory(
            observability: observability
        )
        let synopsisRiddleGenerator = infrastructureFactory.makeSynopsisRiddleGenerator()
        self.applicationFactory = PlotRemixGameApplicationFactory(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            synopsisRiddleGenerator: synopsisRiddleGenerator
        )
    }

    public func makeGeneratePlotRemixGameUseCase() -> GeneratePlotRemixGameUseCase {
        applicationFactory.makeGeneratePlotRemixGameUseCase()
    }

}
