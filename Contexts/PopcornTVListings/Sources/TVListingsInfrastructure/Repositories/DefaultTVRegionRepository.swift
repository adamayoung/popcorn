//
//  DefaultTVRegionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultTVRegionRepository: TVRegionRepository {

    private let localDataSource: any TVListingsLocalDataSource

    init(localDataSource: some TVListingsLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func regions() async throws(TVListingsRepositoryError) -> [TVRegion] {
        do {
            return try await localDataSource.regions()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

}
