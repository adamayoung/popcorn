//
//  IntelligenceApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

package final class IntelligenceApplicationFactory: Sendable {

    private let movieSessionRepository: any MovieLLMSessionRepository
    private let tvSeriesSessionRepository: any TVSeriesLLMSessionRepository

    package init(
        movieSessionRepository: some MovieLLMSessionRepository,
        tvSeriesSessionRepository: some TVSeriesLLMSessionRepository
    ) {
        self.movieSessionRepository = movieSessionRepository
        self.tvSeriesSessionRepository = tvSeriesSessionRepository
    }

    package func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        DefaultCreateMovieIntelligenceSessionUseCase(
            movieSessionRepository: movieSessionRepository
        )
    }

    package func makeCreateTVSeriesIntelligenceSessionUseCase() -> any CreateTVSeriesIntelligenceSessionUseCase {
        DefaultCreateTVSeriesIntelligenceSessionUseCase(
            tvSeriesSessionRepository: tvSeriesSessionRepository
        )
    }

}
