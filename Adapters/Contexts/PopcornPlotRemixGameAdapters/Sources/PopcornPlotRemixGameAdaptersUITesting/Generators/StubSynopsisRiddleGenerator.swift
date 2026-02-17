//
//  StubSynopsisRiddleGenerator.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

final class StubSynopsisRiddleGenerator: SynopsisRiddleGenerating, Sendable {

    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String {
        // swiftlint:disable:next line_length
        "In this tale of wonder, a hero embarks on an epic journey filled with challenges and discoveries. Can you guess which beloved film this describes?"
    }

}
