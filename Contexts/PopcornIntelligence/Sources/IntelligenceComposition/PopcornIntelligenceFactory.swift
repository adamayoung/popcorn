//
//  PopcornIntelligenceFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceApplication
import IntelligenceDomain
import IntelligenceInfrastructure
import Observability

///
/// Main factory for the PopcornIntelligence context
///
public struct PopcornIntelligenceFactory {

    private let applicationFactory: IntelligenceApplicationFactory

    public init(
        movieProvider: some MovieProviding,
        tvSeriesProvider: some TVSeriesProviding,
        creditsProvider: some CreditsProviding
//        observability: some Observing
    ) {
        let infrastructureFactory = IntelligenceInfrastructureFactory(
            movieProvider: movieProvider,
            tvSeriesProvider: tvSeriesProvider,
            creditsProvider: creditsProvider
//            observability: observability
        )

        self.applicationFactory = IntelligenceApplicationFactory(
            movieSessionRepository: infrastructureFactory.makeMovieLLMSessionRepository(),
            tvSeriesSessionRepository: infrastructureFactory.makeTVSeriesLLMSessionRepository()
        )
    }

    public func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> any CreateTVSeriesIntelligenceSessionUseCase {
        applicationFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}
