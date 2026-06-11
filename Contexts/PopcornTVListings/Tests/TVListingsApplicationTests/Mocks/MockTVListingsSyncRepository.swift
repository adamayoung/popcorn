//
//  MockTVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockTVListingsSyncRepository: TVListingsSyncRepository, @unchecked Sendable {

    var syncIfNeededCallCount = 0
    var syncIfNeededStub: Result<Void, TVListingsRepositoryError> = .success(())

    func syncIfNeeded() async throws(TVListingsRepositoryError) {
        syncIfNeededCallCount += 1

        switch syncIfNeededStub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

}
