//
//  MockMovieLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockMovieLLMSessionRepository: MovieLLMSessionRepository, @unchecked Sendable {

    var sessionCallCount = 0
    var sessionCalledWith: [Int] = []
    var sessionStub: Result<any LLMSession, MovieLLMSessionRepositoryError>?

    func session(forMovie movieID: Int) async throws(MovieLLMSessionRepositoryError) -> any LLMSession {
        sessionCallCount += 1
        sessionCalledWith.append(movieID)

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
