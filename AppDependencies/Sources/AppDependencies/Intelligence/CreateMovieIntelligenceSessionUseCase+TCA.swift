//
//  CreateMovieIntelligenceSessionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import IntelligenceApplication
import IntelligenceComposition
import PopcornIntelligenceAdapters

enum CreateMovieIntelligenceSessionUseCaseKey: DependencyKey {

    static var liveValue: any CreateMovieIntelligenceSessionUseCase {
        @Dependency(\.intelligenceFactory) var intelligenceFactory
        return intelligenceFactory.makeCreateMovieIntelligenceSessionUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for creating an intelligence session for a movie.
    ///
    /// Creates an AI-powered conversation session focused on a specific movie
    /// for interactive question and answer functionality.
    ///
    var createMovieIntelligenceSession: any CreateMovieIntelligenceSessionUseCase {
        get { self[CreateMovieIntelligenceSessionUseCaseKey.self] }
        set { self[CreateMovieIntelligenceSessionUseCaseKey.self] = newValue }
    }

}
