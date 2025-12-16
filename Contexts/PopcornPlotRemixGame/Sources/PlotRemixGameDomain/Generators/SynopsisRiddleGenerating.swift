//
//  SynopsisRiddleGenerating.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
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
