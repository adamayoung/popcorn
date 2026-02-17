//
//  CreateMovieIntelligenceSessionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var createMovieIntelligenceSession: any CreateMovieIntelligenceSessionUseCase {
        get { self[CreateMovieIntelligenceSessionUseCaseKey.self] }
        set { self[CreateMovieIntelligenceSessionUseCaseKey.self] = newValue }
    }

}
