//
//  GeneratePlotRemixGameUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameApplication

enum GeneratePlotRemixGameUseCaseKey: DependencyKey {

    static var liveValue: any GeneratePlotRemixGameUseCase {
        @Dependency(\.plotRemixGameFactory) var plotRemixGameFactory
        return plotRemixGameFactory.makeGeneratePlotRemixGameUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for generating a plot remix game.
    ///
    /// Creates a new game with AI-generated movie riddles and multiple
    /// choice questions for users to guess.
    ///
    var generatePlotRemixGame: any GeneratePlotRemixGameUseCase {
        get { self[GeneratePlotRemixGameUseCaseKey.self] }
        set { self[GeneratePlotRemixGameUseCaseKey.self] = newValue }
    }

}
