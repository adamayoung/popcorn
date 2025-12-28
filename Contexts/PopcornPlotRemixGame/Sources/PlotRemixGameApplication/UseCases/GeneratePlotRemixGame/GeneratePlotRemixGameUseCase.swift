//
//  GeneratePlotRemixGameUseCase.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

///
/// A use case protocol for generating Plot Remix game sessions.
///
/// Implementations orchestrate the complete game generation workflow, including
/// movie selection, riddle generation, and question assembly. The use case supports
/// progress reporting for UI feedback during the potentially lengthy generation process.
///
public protocol GeneratePlotRemixGameUseCase: Sendable {

    ///
    /// Generates a new Plot Remix game session based on the provided configuration.
    ///
    /// This asynchronous operation selects movies matching the configuration filters,
    /// generates themed riddles for each movie using AI, and assembles complete questions
    /// with multiple choice answers. Progress is reported incrementally as questions are
    /// generated.
    ///
    /// - Parameters:
    ///   - config: The game configuration specifying theme, genre, and year filters.
    ///   - progress: A closure called with progress values from 0.0 to 1.0 as generation proceeds.
    /// - Returns: A fully generated game ready for play.
    /// - Throws: ``GeneratePlotRemixGameError`` if game generation fails at any stage.
    ///
    func execute(
        config: GameConfig,
        progress: @Sendable @escaping (Float) -> Void
    ) async throws(GeneratePlotRemixGameError) -> Game

}
