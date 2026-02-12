//
//  StubLLMSession.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

final class StubLLMSession: LLMSession, Sendable {

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        // swiftlint:disable:next line_length
        "This is a stub response for UI testing. The AI assistant would normally provide helpful information about the movie or TV series here."
    }

}
