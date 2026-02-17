//
//  IntelligenceApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

/// Represents ``IntelligenceApplicationFactory``.
public final class IntelligenceApplicationFactory: Sendable {

    private let movieSessionRepository: any MovieLLMSessionRepository
    private let tvSeriesSessionRepository: any TVSeriesLLMSessionRepository

    /// Creates a new instance.
    public init(
        movieSessionRepository: some MovieLLMSessionRepository,
        tvSeriesSessionRepository: some TVSeriesLLMSessionRepository
    ) {
        self.movieSessionRepository = movieSessionRepository
        self.tvSeriesSessionRepository = tvSeriesSessionRepository
    }

    /// Executes ``makeCreateMovieIntelligenceSessionUseCase``.
    public func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        DefaultCreateMovieIntelligenceSessionUseCase(
            movieSessionRepository: movieSessionRepository
        )
    }

    /// Executes ``makeCreateTVSeriesIntelligenceSessionUseCase``.
    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> any CreateTVSeriesIntelligenceSessionUseCase {
        DefaultCreateTVSeriesIntelligenceSessionUseCase(
            tvSeriesSessionRepository: tvSeriesSessionRepository
        )
    }

}
