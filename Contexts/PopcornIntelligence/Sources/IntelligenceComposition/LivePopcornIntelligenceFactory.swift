//
//  LivePopcornIntelligenceFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceApplication
import IntelligenceDomain
import IntelligenceInfrastructure

public final class LivePopcornIntelligenceFactory: PopcornIntelligenceFactory {

    private let applicationFactory: IntelligenceApplicationFactory

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

    public func makeCreateMovieIntelligenceSessionUseCase() -> CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> CreateTVSeriesIntelligenceSessionUseCase {
        applicationFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}
