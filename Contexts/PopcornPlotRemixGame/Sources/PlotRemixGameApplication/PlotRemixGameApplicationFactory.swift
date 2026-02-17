//
//  PlotRemixGameApplicationFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

public final class PlotRemixGameApplicationFactory: Sendable {

    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieProvider: any MovieProviding
    private let genreProvider: any GenreProviding
    private let synopsisRiddleGenerator: any SynopsisRiddleGenerating

    public init(
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
