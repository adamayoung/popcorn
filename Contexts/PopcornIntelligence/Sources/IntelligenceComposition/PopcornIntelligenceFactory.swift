//
//  PopcornIntelligenceFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceApplication

public protocol PopcornIntelligenceFactory: Sendable {

    func makeCreateMovieIntelligenceSessionUseCase() -> CreateMovieIntelligenceSessionUseCase

    func makeCreateTVSeriesIntelligenceSessionUseCase() -> CreateTVSeriesIntelligenceSessionUseCase

}
