//
//  StubTVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
