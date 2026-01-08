//
//  CreateTVSeriesIntelligenceSessionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import IntelligenceApplication
import IntelligenceComposition
import PopcornIntelligenceAdapters

enum CreateTVSeriesIntelligenceSessionUseCaseKey: DependencyKey {

    static var liveValue: any CreateTVSeriesIntelligenceSessionUseCase {
        @Dependency(\.intelligenceFactory) var intelligenceFactory
        return intelligenceFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}

public extension DependencyValues {

    var createTVSeriesIntelligenceSession: any CreateTVSeriesIntelligenceSessionUseCase {
        get { self[CreateTVSeriesIntelligenceSessionUseCaseKey.self] }
        set { self[CreateTVSeriesIntelligenceSessionUseCaseKey.self] = newValue }
    }

}
