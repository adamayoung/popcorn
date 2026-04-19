//
//  MockTVListingsRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain
@testable import TVListingsInfrastructure

final class MockTVListingsRemoteDataSource: TVListingsRemoteDataSource, @unchecked Sendable {

    var fetchListingsStub: Result<TVListingsSnapshot, TVListingsRemoteDataSourceError> =
        .success(TVListingsSnapshot(channels: [], programmes: []))
    var fetchListingsCallCount = 0

    func fetchListings() async throws(TVListingsRemoteDataSourceError) -> TVListingsSnapshot {
        fetchListingsCallCount += 1
        switch fetchListingsStub {
        case .success(let snapshot): return snapshot
        case .failure(let error): throw error
        }
    }

}
