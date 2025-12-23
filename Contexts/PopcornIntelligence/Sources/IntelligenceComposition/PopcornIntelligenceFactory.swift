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
        movieProvider: some MovieProviding
//        tvSeriesProvider: some TVSeriesProviding,
//        observability: some Observing
    ) {
        let infrastructureFactory = IntelligenceInfrastructureFactory(
            movieProvider: movieProvider
//            tvSeriesProvider: tvSeriesProvider,
//            observability: observability
        )

        self.applicationFactory = IntelligenceApplicationFactory(
            movieSessionRepository: infrastructureFactory.makeMovieLLMSessionRepository()
        )
    }

    public func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

}
