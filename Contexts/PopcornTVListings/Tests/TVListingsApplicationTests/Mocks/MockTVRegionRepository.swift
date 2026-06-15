//
//  MockTVRegionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockTVRegionRepository: TVRegionRepository, @unchecked Sendable {

    var regionsCallCount = 0
    var regionsStub: Result<[TVRegion], TVListingsRepositoryError> = .success([])

    func regions() async throws(TVListingsRepositoryError) -> [TVRegion] {
        regionsCallCount += 1

        switch regionsStub {
        case .success(let regions):
            return regions
        case .failure(let error):
            throw error
        }
    }

}
