//
//  LLMSession+Mocks.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockLLMSession: LLMSession, @unchecked Sendable {

    var respondCallCount = 0
    var respondCalledWith: [String] = []
    var respondStub: Result<String, LLMSessionError>?

    func respond(to prompt: String) async throws(LLMSessionError) -> String {
        respondCallCount += 1
        respondCalledWith.append(prompt)

        guard let stub = respondStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

}
