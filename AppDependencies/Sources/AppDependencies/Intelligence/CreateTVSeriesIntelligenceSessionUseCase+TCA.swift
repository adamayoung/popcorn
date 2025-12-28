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

// swiftlint:disable:next type_name
enum CreateTVSeriesIntelligenceSessionUseCaseKey: DependencyKey {

    static var liveValue: any CreateTVSeriesIntelligenceSessionUseCase {
        @Dependency(\.intelligenceFactory) var intelligenceFactory
        return intelligenceFactory.makeCreateTVSeriesIntelligenceSessionUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for creating an intelligence session for a TV series.
    ///
    /// Creates an AI-powered conversation session focused on a specific TV series
    /// for interactive question and answer functionality.
    ///
    var createTVSeriesIntelligenceSession: any CreateTVSeriesIntelligenceSessionUseCase {
        get { self[CreateTVSeriesIntelligenceSessionUseCaseKey.self] }
        set { self[CreateTVSeriesIntelligenceSessionUseCaseKey.self] = newValue }
    }

}
