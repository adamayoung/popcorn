//
//  DefaultFetchTVRegionsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVRegionsUseCase: FetchTVRegionsUseCase {

    private let tvRegionRepository: any TVRegionRepository

    init(tvRegionRepository: some TVRegionRepository) {
        self.tvRegionRepository = tvRegionRepository
    }

    func execute() async throws(FetchTVRegionsError) -> [TVRegion] {
        do {
            return try await tvRegionRepository.regions()
        } catch let error {
            throw FetchTVRegionsError(error)
        }
    }

}
