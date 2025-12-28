//
//  PopcornPlotRemixGameFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Observability
import PlotRemixGameApplication
import PlotRemixGameDomain
import PlotRemixGameInfrastructure

///
/// A factory for creating Plot Remix game use cases and dependencies.
///
/// This factory serves as the composition root for the Plot Remix game context,
/// assembling application and infrastructure layer components with their required
/// dependencies. External adapters for configuration, movie data, and genres are
/// injected to maintain clean architecture boundaries.
///
public struct PopcornPlotRemixGameFactory {

    private let applicationFactory: PlotRemixGameApplicationFactory

    ///
    /// Creates a new Plot Remix game factory with the required dependencies.
    ///
    /// - Parameters:
    ///   - appConfigurationProvider: Provides application configuration settings.
    ///   - movieProvider: Provides movie data for question generation.
    ///   - genreProvider: Provides genre data for game filtering options.
    ///   - observability: Provides error reporting and monitoring capabilities.
    ///
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

    ///
    /// Creates a use case for generating Plot Remix game sessions.
    ///
    /// - Returns: A configured use case for game generation.
    ///
    public func makeGeneratePlotRemixGameUseCase() -> some GeneratePlotRemixGameUseCase {
        applicationFactory.makeGeneratePlotRemixGameUseCase()
    }

}
