//
//  GeneratePlotRemixGameUseCase+TCA.swift
//  PopcornPlotRemixGameAdapters
//
//  Created by Adam Young on 11/12/2025.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameApplication

enum GeneratePlotRemixGameUseCaseKey: DependencyKey {

    static var liveValue: any GeneratePlotRemixGameUseCase {
        @Dependency(\.plotRemixGameApplicationFactory) var plotRemixGameApplicationFactory
        return plotRemixGameApplicationFactory.makeGeneratePlotRemixGameUseCase()
    }

}

extension DependencyValues {

    public var generatePlotRemixGame: any GeneratePlotRemixGameUseCase {
        get { self[GeneratePlotRemixGameUseCaseKey.self] }
        set { self[GeneratePlotRemixGameUseCaseKey.self] = newValue }
    }

}
