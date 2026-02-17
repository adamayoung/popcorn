//
//  PopcornIntelligenceFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceApplication

/// Defines the ``PopcornIntelligenceFactory`` contract.
public protocol PopcornIntelligenceFactory: Sendable {

    func makeCreateMovieIntelligenceSessionUseCase() -> CreateMovieIntelligenceSessionUseCase

    func makeCreateTVSeriesIntelligenceSessionUseCase() -> CreateTVSeriesIntelligenceSessionUseCase

}
