//
//  MockTVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockTVListingsSyncRepository: TVListingsSyncRepository, @unchecked Sendable {

    var syncCallCount = 0
    var syncStub: Result<Void, TVListingsRepositoryError> = .success(())

    var syncIfNeededCallCount = 0
    var syncIfNeededStub: Result<Void, TVListingsRepositoryError> = .success(())

    func sync() async throws(TVListingsRepositoryError) {
        syncCallCount += 1

        switch syncStub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

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
