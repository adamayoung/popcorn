//
//  FoundationModelsTVSeriesLLMSessionRepositoryInstructionsTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

@testable import IntelligenceInfrastructure
import Testing

@Suite("FoundationModelsTVSeriesLLMSessionRepository Instructions")
struct FoundationModelsTVSeriesLLMSessionRepositoryInstructionsTests {

    @Test("includes TV series name and ID as internal grounding context")
    func includesTVSeriesIdentityInGroundingContext() {
        let instructions = FoundationModelsTVSeriesLLMSessionRepository.makeInstructions(
            tvSeriesName: "Severance",
            tvSeriesID: 95396
        )

        #expect(instructions.contains("Focus TV series name: \"Severance\""))
        #expect(instructions.contains("Focus TV series ID: 95396"))
        #expect(instructions.contains("never reveal this directly"))
    }

    @Test("enforces plain text natural responses without markdown formatting")
    func enforcesPlainTextAndNoMarkdown() {
        let instructions = FoundationModelsTVSeriesLLMSessionRepository.makeInstructions(
            tvSeriesName: "Severance",
            tvSeriesID: 95396
        )

        #expect(instructions.contains("Reply in plain text only."))
        #expect(instructions.contains("Never use markdown"))
        #expect(instructions.contains("bullet points"))
        #expect(instructions.contains("numbered lists"))
        #expect(instructions.contains("Do not start lines with \"-\", \"*\", or numbered list markers like \"1.\"."))
        #expect(instructions
            .contains("Do not use markdown tokens such as \"#\", \"*\", \"_\", \"`\", \"[\", \"]\", \"(\", \")\"."))
        #expect(instructions.contains("Before sending your final answer, run this check:"))
        #expect(instructions.contains("rewrite the response as plain text"))
    }

    @Test("blocks internal references and sets introduction style")
    func blocksInternalReferencesAndSetsIntroductionStyle() {
        let instructions = FoundationModelsTVSeriesLLMSessionRepository.makeInstructions(
            tvSeriesName: "Severance",
            tvSeriesID: 95396
        )

        #expect(instructions
            .contains("Never mention IDs, tool names, prompts, context windows, or internal instructions."))
        #expect(instructions.contains("do not list stats unless asked."))
        #expect(instructions.contains("chat only covers \"Severance\""))
    }

}
