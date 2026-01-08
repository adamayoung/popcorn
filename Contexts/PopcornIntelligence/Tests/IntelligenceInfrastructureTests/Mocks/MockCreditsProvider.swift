//
//  MockCreditsProvider.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockCreditsProvider: CreditsProviding, @unchecked Sendable {

    var creditsForMovieCallCount = 0
    var creditsForMovieCalledWith: [Int] = []
    var creditsForMovieStub: Result<Credits, CreditsProviderError>?

    func credits(forMovie movieID: Int) async throws(CreditsProviderError) -> Credits {
        creditsForMovieCallCount += 1
        creditsForMovieCalledWith.append(movieID)

        guard let stub = creditsForMovieStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

}
