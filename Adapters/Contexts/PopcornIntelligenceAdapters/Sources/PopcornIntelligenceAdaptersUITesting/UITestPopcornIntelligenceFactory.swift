//
//  UITestPopcornIntelligenceFactory.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceApplication
import IntelligenceComposition
import IntelligenceDomain

public final class UITestPopcornIntelligenceFactory: PopcornIntelligenceFactory {

    private let applicationFactory: IntelligenceApplicationFactory

    public init() {
        self.applicationFactory = IntelligenceApplicationFactory(
            movieSessionRepository: StubMovieLLMSessionRepository(),
            tvSeriesSessionRepository: StubTVSeriesLLMSessionRepository()
        )
    }

    public func makeCreateMovieIntelligenceSessionUseCase() -> CreateMovieIntelligenceSessionUseCase {
        applicationFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

    public func makeCreateTVSeriesIntelligenceSessionUseCase() -> CreateTVSeriesIntelligenceSessionUseCase {
        applicationFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}
