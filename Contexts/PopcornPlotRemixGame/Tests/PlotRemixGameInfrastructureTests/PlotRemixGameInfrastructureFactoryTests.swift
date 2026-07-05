//
//  PlotRemixGameInfrastructureFactoryTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import ObservabilityTestHelpers
import PlotRemixGameDomain
@testable import PlotRemixGameInfrastructure
import Testing

@Suite("PlotRemixGameInfrastructureFactory")
struct PlotRemixGameInfrastructureFactoryTests {

    @Test("makeSynopsisRiddleGenerator returns a generator conforming to SynopsisRiddleGenerating")
    func makeSynopsisRiddleGeneratorReturnsGenerator() {
        let observability = MockObservability()
        let factory = PlotRemixGameInfrastructureFactory(observability: observability)

        let generator = factory.makeSynopsisRiddleGenerator()

        #expect(generator is FoundationModelsSynopsisRiddleGenerator)
    }

}
