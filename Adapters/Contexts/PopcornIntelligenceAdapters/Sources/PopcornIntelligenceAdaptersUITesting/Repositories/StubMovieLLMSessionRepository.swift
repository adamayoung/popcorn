//
//  StubMovieLLMSessionRepository.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

public final class StubMovieLLMSessionRepository: MovieLLMSessionRepository, Sendable {

    public init() {}

    public func session(
        forMovie movieID: Int
    ) async throws(MovieLLMSessionRepositoryError) -> any LLMSession {
        StubLLMSession()
    }

}
