//
//  PopcornIntelligenceFactory.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceApplication
import IntelligenceDomain
import IntelligenceInfrastructure
import Observability

///
/// Main factory for the PopcornIntelligence context.
///
/// This factory serves as the primary entry point for creating intelligence-related
/// use cases. It composes the application and infrastructure layers, wiring up
/// all necessary dependencies for movie and TV series intelligence features.
///
public struct PopcornIntelligenceFactory {

    private let applicationFactory: IntelligenceApplicationFactory

    ///
    /// Creates a new PopcornIntelligence factory with the required providers.
    ///
    /// - Parameters:
    ///   - movieProvider: A provider that supplies movie data for intelligence sessions.
    ///   - tvSeriesProvider: A provider that supplies TV series data for intelligence sessions.
    ///
    public init(
        movieProvider: some MovieProviding,
        tvSeriesProvider: some TVSeriesProviding
//        observability: some Observing
    ) {
        let infrastructureFactory = IntelligenceInfrastructureFactory(
            movieProvider: movieProvider,
            tvSeriesProvider: tvSeriesProvider
//            observability: observability
        )

        self.applicationFactory = IntelligenceApplicationFactory(
            movieSessionRepository: infrastructureFactory.makeMovieLLMSessionRepository(),
            tvSeriesSessionRepository: infrastructureFactory.makeTVSeriesLLMSessionRepository()
        )
    }

    ///
    /// Creates a use case for creating movie intelligence sessions.
    ///
    /// - Returns: A configured ``CreateMovieIntelligenceSessionUseCase`` instance.
    ///
    public func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

    ///
    /// Creates a use case for creating TV series intelligence sessions.
    ///
    /// - Returns: A configured ``CreateTVSeriesIntelligenceSessionUseCase`` instance.
    ///
    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> any CreateTVSeriesIntelligenceSessionUseCase {
        applicationFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}
