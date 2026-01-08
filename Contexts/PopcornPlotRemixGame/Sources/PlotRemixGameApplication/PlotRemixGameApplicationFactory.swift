//
//  PlotRemixGameApplicationFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

package final class PlotRemixGameApplicationFactory: Sendable {

    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieProvider: any MovieProviding
    private let genreProvider: any GenreProviding
    private let synopsisRiddleGenerator: any SynopsisRiddleGenerating

    package init(
        appConfigurationProvider: some AppConfigurationProviding,
        movieProvider: some MovieProviding,
        genreProvider: some GenreProviding,
        synopsisRiddleGenerator: some SynopsisRiddleGenerating
    ) {
        self.appConfigurationProvider = appConfigurationProvider
        self.movieProvider = movieProvider
        self.genreProvider = genreProvider
        self.synopsisRiddleGenerator = synopsisRiddleGenerator
    }

    package func makeGeneratePlotRemixGameUseCase() -> some GeneratePlotRemixGameUseCase {
        DefaultGeneratePlotRemixGameUseCase(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            synopsisRiddleGenerator: synopsisRiddleGenerator
        )
    }

}
