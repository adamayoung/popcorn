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

    /// Values fed to the `onProgress` callback (in order) before `syncIfNeeded` returns,
    /// letting a test assert the use case forwards them.
    var progressToEmit: [Float] = []

    func syncIfNeeded(onProgress: @Sendable @escaping (Float) -> Void) async throws(TVListingsRepositoryError) {
        syncIfNeededCallCount += 1

        for value in progressToEmit {
            onProgress(value)
        }

        switch syncIfNeededStub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

}
