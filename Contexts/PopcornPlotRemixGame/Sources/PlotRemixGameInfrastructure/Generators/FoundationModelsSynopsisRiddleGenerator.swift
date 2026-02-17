//
//  FoundationModelsSynopsisRiddleGenerator.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import Observability
import OSLog
import PlotRemixGameDomain

final class FoundationModelsSynopsisRiddleGenerator: SynopsisRiddleGenerating {

    private static let logger = Logger.plotRemixGameInfrastructure

    /// Cache instruction phrases to avoid repeated computation
    private static let instructionPhrasesByTheme: [GameTheme: String] = Dictionary(
        uniqueKeysWithValues: GameTheme.allCases.map { theme in
            (theme, FoundationModelsSynopsisRiddleGenerator.instructionPhrase(for: theme))
        }
    )

    private let observability: any Observing

    init(observability: some Observing) {
        self.observability = observability
    }

    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String {
        let instructions = try Self.createInstructions(for: theme)
        let session = LanguageModelSession(instructions: instructions)

        let prompt = """
        Rewrite the following movie synopsis according to your style.

        Title: \(movie.title)
        Synopsis:
        \(movie.overview)
        """

        let response: LanguageModelSession.Response<String>
        do {
            response = try await session.respond(to: prompt)
        } catch let error {
            observability.capture(
                error: error,
                extras: [
                    "movie_id": movie.id,
                    "movie_title": movie.title,
                    "prompt": prompt
                ]
            )
            Self.logger.error(
                "Failed to create riddle for '\(movie.title, privacy: .private)': \(error.localizedDescription, privacy: .public)"
            )
            throw .generation(error)
        }

        let content = response.content.description

        // Validate response quality
        guard !content.isEmpty, content.count >= 20 else {
            Self.logger.warning(
                "Received unusually short response  [movieID: \(movie.id, privacy: .private), content: \"\(content, privacy: .private)\""
            )
            throw .generation(nil)
        }

        return content
    }

    private static func createInstructions(for theme: GameTheme)
    throws(SynopsisRiddleGeneratorError) -> String {
        guard let themeInstructions = instructionPhrasesByTheme[theme] else {
            throw .generation()
        }

        return """
        You are a quiz master who rewrites movie summaries using the style defined by \(
            themeInstructions
        ) for a person to guess.

        --- RULES ---
        - Preserve the core plot: the main conflict, 3-5 key events, and the resolution
        - Replace specific names with descriptive roles (e.g., "a detective", "two siblings")
        - Replace specific locations with generic settings (e.g., "a coastal town", "deep space")
        - Change surface details (professions, time periods, objects) while keeping the story logic
        - DO NOT include character names, actor names, movie titles, franchise names, or unique invented terms
        - DO NOT reference release years, awards, taglines, or famous quotes
        - Keep the same general tone as the original (serious plots stay serious, comedies stay light)
        - Output ONLY the rewritten summary as 2-4 sentences in plain text
        """
    }

}

extension FoundationModelsSynopsisRiddleGenerator {

    private static func instructionPhrase(for theme: GameTheme) -> String {
        switch theme {
        case .darkCryptic:
            "dark, cryptic riddles"

        case .whimsical:
            "whimsical dream-logic riddles"

        case .noir:
            "gritty noir monologues"

        case .mythic:
            "ancient myths or heroic epics"

        case .fairyTale:
            "old folklore or cautionary fairy tales"

        case .sciFiOracle:
            "cryptic transmissions from a distant AI oracle"

        case .humorous:
            "sarcastic, deadpan commentaries with sharp humor"

        case .poetic:
            "lyrical, poetic verse"

        case .legalese:
            "legalese - legal jargon and technical jargon"

        case .child:
            "a child"

        case .pirate:
            "a pirate like Jack Sparrow"

        case .minimalist:
            "ultra-minimal, koan-like phrasing"
        }
    }

}
