//
//  LivePopcornIntelligenceFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceApplication
import IntelligenceDomain
import IntelligenceInfrastructure

/// Represents ``LivePopcornIntelligenceFactory``.
public final class LivePopcornIntelligenceFactory: PopcornIntelligenceFactory {

    private let applicationFactory: IntelligenceApplicationFactory

    /// Creates a new instance.
    public init(
        movieProvider: some MovieProviding,
        tvSeriesProvider: some TVSeriesProviding,
        creditsProvider: some CreditsProviding
    ) {
        let infrastructureFactory = IntelligenceInfrastructureFactory(
            movieProvider: movieProvider,
            tvSeriesProvider: tvSeriesProvider,
            creditsProvider: creditsProvider
        )

        self.applicationFactory = IntelligenceApplicationFactory(
            movieSessionRepository: infrastructureFactory.makeMovieLLMSessionRepository(),
            tvSeriesSessionRepository: infrastructureFactory.makeTVSeriesLLMSessionRepository()
        )
    }

    /// Executes ``makeCreateMovieIntelligenceSessionUseCase``.
    public func makeCreateMovieIntelligenceSessionUseCase() -> CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

    /// Executes ``makeCreateTVSeriesIntelligenceSessionUseCase``.
    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> CreateTVSeriesIntelligenceSessionUseCase {
        applicationFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}
