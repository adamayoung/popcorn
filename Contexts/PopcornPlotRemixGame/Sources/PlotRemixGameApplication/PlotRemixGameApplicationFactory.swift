//
//  QuizApplicationFactory.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import PlotRemixGameDomain

public final class PlotRemixGameApplicationFactory {

    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieProvider: any MovieProviding
    private let genreProvider: any GenreProviding
    private let synopsisRiddleGenerator: any SynopsisRiddleGenerating

    init(
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

    public func makeGeneratePlotRemixGameUseCase() -> some GeneratePlotRemixGameUseCase {
        DefaultGeneratePlotRemixGameUseCase(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            synopsisRiddleGenerator: synopsisRiddleGenerator
        )
    }

}
