//
//  PopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 15/12/2025.
//

import Foundation
import PlotRemixGameApplication
import PlotRemixGameDomain
import PlotRemixGameInfrastructure

public struct PopcornPlotRemixGameFactory {

    private let applicationFactory: PlotRemixGameApplicationFactory

    public init(
        appConfigurationProvider: some AppConfigurationProviding,
        movieProvider: some MovieProviding,
        genreProvider: some GenreProviding
    ) {
        let infrastructureFactory = PlotRemixGameInfrastructureFactory()
        let synopsisRiddleGenerator = infrastructureFactory.makeSynopsisRiddleGenerator()
        self.applicationFactory = PlotRemixGameApplicationFactory(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            synopsisRiddleGenerator: synopsisRiddleGenerator
        )
    }

    public func makeGeneratePlotRemixGameUseCase() -> some GeneratePlotRemixGameUseCase {
        applicationFactory.makeGeneratePlotRemixGameUseCase()
    }

}
