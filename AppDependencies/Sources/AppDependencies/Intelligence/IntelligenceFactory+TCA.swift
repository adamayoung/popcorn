//
//  IntelligenceFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import IntelligenceComposition
import PopcornIntelligenceAdapters

extension DependencyValues {

    var intelligenceFactory: PopcornIntelligenceFactory {
        PopcornIntelligenceAdaptersFactory(
            fetchMovieDetailsUseCase: fetchMovieDetails
        ).makeIntelligenceFactory()
    }

}
