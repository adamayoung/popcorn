//
//  FoundationModelsSynopsisRiddleGeneratorTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import ObservabilityTestHelpers
import PlotRemixGameDomain
@testable import PlotRemixGameInfrastructure
import Testing

/// `FoundationModelsSynopsisRiddleGenerator` wraps Apple's on-device FoundationModels
/// language model. Its `riddle(for:theme:)` method drives a real `LanguageModelSession`,
/// which requires Apple Intelligence to be available and enabled on the running device --
/// unsuitable for a deterministic, hermetic unit test. Its other logic (theme instruction
/// lookup, prompt building, response validation) is `private`, so it isn't reachable even
/// via `@testable import`.
///
/// These tests therefore only cover the deterministic, testable seam: that the type can be
/// constructed with an injected `Observing` dependency and conforms to
/// `SynopsisRiddleGenerating`. Exercising `riddle(for:theme:)` itself needs on-device /
/// manual verification and is intentionally left uncovered here.
@Suite("FoundationModelsSynopsisRiddleGenerator")
struct FoundationModelsSynopsisRiddleGeneratorTests {

    @Test("init constructs a generator conforming to SynopsisRiddleGenerating")
    func initConstructsGenerator() {
        let observability = MockObservability()

        let generator: any SynopsisRiddleGenerating = FoundationModelsSynopsisRiddleGenerator(
            observability: observability
        )

        #expect(generator is FoundationModelsSynopsisRiddleGenerator)
    }

}
