//
//  SynopsisRiddleGenerating.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol for generating creative plot riddles from movie synopses.
///
/// Implementations transform movie plot summaries into thematic riddles that obscure
/// the source material while preserving core narrative elements. The generated riddles
/// serve as questions in Plot Remix games where players identify movies from remixed
/// descriptions.
///
public protocol SynopsisRiddleGenerating: Sendable {

    ///
    /// Generates a themed riddle from a movie's plot synopsis.
    ///
    /// - Parameters:
    ///   - movie: The movie whose synopsis will be transformed into a riddle.
    ///   - theme: The narrative style to apply when rewriting the plot.
    /// - Returns: A creatively rewritten plot description in the specified theme.
    /// - Throws: ``SynopsisRiddleGeneratorError`` if riddle generation fails.
    ///
    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String

}

///
/// Errors that can occur during synopsis riddle generation.
///
public enum SynopsisRiddleGeneratorError: Error {

    /// The riddle generation process failed.
    case generation(Error? = nil)

    /// An unknown error occurred during generation.
    case unknown(Error? = nil)

}
