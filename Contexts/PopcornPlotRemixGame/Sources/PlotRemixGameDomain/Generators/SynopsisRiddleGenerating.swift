//
//  SynopsisRiddleGenerating.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol SynopsisRiddleGenerating: Sendable {

    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String

}

public enum SynopsisRiddleGeneratorError: Error {

    case generation(Error? = nil)
    case unknown(Error? = nil)

}
