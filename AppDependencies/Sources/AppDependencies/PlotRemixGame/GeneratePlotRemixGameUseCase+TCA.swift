//
//  GeneratePlotRemixGameUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var generatePlotRemixGame: any GeneratePlotRemixGameUseCase {
        get { self[GeneratePlotRemixGameUseCaseKey.self] }
        set { self[GeneratePlotRemixGameUseCaseKey.self] = newValue }
    }

}
