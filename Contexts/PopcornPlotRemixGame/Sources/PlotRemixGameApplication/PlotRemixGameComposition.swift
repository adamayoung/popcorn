//
//  PlotRemixGameComposition.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import PlotRemixGameDomain
import PlotRemixGameInfrastructure

public struct PlotRemixGameComposition {

    private init() {}

    public static func makeGameFactory(
        appConfigurationProvider: some AppConfigurationProviding,
        movieProvider: some MovieProviding,
        genreProvider: some GenreProviding,
    ) -> PlotRemixGameApplicationFactory {
        let infrastructureFactory = PlotRemixGameInfrastructureFactory()
        let synopsisRiddleGenerator = infrastructureFactory.makeSynopsisRiddleGenerator()

        return PlotRemixGameApplicationFactory(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            synopsisRiddleGenerator: synopsisRiddleGenerator
        )
    }

}
