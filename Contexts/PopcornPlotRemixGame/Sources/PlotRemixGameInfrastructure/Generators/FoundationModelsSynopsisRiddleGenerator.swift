//
//  FoundationModelsSynopsisRiddleGenerator.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import FoundationModels
import PlotRemixGameDomain

final class FoundationModelsSynopsisRiddleGenerator: SynopsisRiddleGenerating {

    init() {}

    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String {
        let instructions = """
                You rewrite movie summaries as \(instructionPhrases(for: theme)).
                Keep core plot beats.
                DO NOT mention movie titles.
                DO NOT mention character names.
                DO NOT mention Place names.
                DO NOT mention explicit title.
                DO NOT generate unsafe content that would trigger safety guardrails.
                Give the summary ONLY.
            """

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
            throw .generation(error)
        }

        return response.content.description
    }

}

extension FoundationModelsSynopsisRiddleGenerator {

    private func instructionPhrases(for theme: GameTheme) -> String {
        switch theme {
        case .darkCryptic:
            return "dark, cryptic riddles"

        case .whimsical:
            return "whimsical dream-logic riddles"

        case .noir:
            return "gritty noir monologues"

        case .mythic:
            return "ancient myths or heroic epics"

        case .fairyTale:
            return "old folklore or cautionary fairy tales"

        case .sciFiOracle:
            return "cryptic transmissions from a distant AI oracle"

        case .humorous:
            return "sarcastic, deadpan commentaries with sharp humor"

        case .poetic:
            return "lyrical, poetic verse"

        case .legalese:
            return "legalese - legal jargon and technical jargon"

        case .child:
            return "a child"

        case .pirate:
            return "a pirate like Jack Sparrow"

        case .minimalist:
            return "ultra-minimal, koan-like phrasing"
        }
    }

}
