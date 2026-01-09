//
//  StubMovieLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
