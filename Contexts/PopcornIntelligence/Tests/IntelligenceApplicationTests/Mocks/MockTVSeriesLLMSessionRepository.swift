//
//  MockTVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockTVSeriesLLMSessionRepository: TVSeriesLLMSessionRepository, @unchecked Sendable {

    var sessionCallCount = 0
    var sessionCalledWith: [Int] = []
    var sessionStub: Result<any LLMSession, TVSeriesLLMSessionRepositoryError>?

    func session(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession {
        sessionCallCount += 1
        sessionCalledWith.append(tvSeriesID)

        guard let stub = sessionStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }

}
