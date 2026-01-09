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

enum PopcornIntelligenceFactoryKey: DependencyKey {

    static var liveValue: PopcornIntelligenceFactory {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails
        @Dependency(\.fetchMovieCredits) var fetchMovieCredits
        return PopcornIntelligenceAdaptersFactory(
            fetchMovieDetailsUseCase: fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetails,
            fetchMovieCreditsUseCase: fetchMovieCredits
        ).makeIntelligenceFactory()
    }

}

extension DependencyValues {

    var intelligenceFactory: PopcornIntelligenceFactory {
        get { self[PopcornIntelligenceFactoryKey.self] }
        set { self[PopcornIntelligenceFactoryKey.self] = newValue }
    }

}
