//
//  IntelligenceApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

public final class IntelligenceApplicationFactory: Sendable {

    private let movieSessionRepository: any MovieLLMSessionRepository
    private let tvSeriesSessionRepository: any TVSeriesLLMSessionRepository

    public init(
        movieSessionRepository: some MovieLLMSessionRepository,
        tvSeriesSessionRepository: some TVSeriesLLMSessionRepository
    ) {
        self.movieSessionRepository = movieSessionRepository
        self.tvSeriesSessionRepository = tvSeriesSessionRepository
    }

    public func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        DefaultCreateMovieIntelligenceSessionUseCase(
            movieSessionRepository: movieSessionRepository
        )
    }

    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> any CreateTVSeriesIntelligenceSessionUseCase {
        DefaultCreateTVSeriesIntelligenceSessionUseCase(
            tvSeriesSessionRepository: tvSeriesSessionRepository
        )
    }

}
