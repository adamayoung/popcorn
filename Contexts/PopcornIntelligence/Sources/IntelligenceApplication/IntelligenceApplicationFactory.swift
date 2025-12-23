//
//  IntelligenceApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

package final class IntelligenceApplicationFactory {

    private let movieSessionRepository: any MovieLLMSessionRepository

    package init(
        movieSessionRepository: some MovieLLMSessionRepository
    ) {
        self.movieSessionRepository = movieSessionRepository
    }

    package func makeCreateMovieIntelligenceSessionUseCase() -> any CreateMovieIntelligenceSessionUseCase {
        DefaultCreateMovieIntelligenceSessionUseCase(
            movieSessionRepository: movieSessionRepository
        )
    }

}
