//
//  StubTVSeriesLLMSessionRepository.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

public final class StubTVSeriesLLMSessionRepository: TVSeriesLLMSessionRepository, Sendable {

    public init() {}

    public func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession {
        StubLLMSession()
    }

}
