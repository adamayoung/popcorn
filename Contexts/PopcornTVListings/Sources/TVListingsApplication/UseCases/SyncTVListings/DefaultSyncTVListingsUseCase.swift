//
//  DefaultSyncTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultSyncTVListingsUseCase: SyncTVListingsUseCase {

    private let tvListingsSyncRepository: any TVListingsSyncRepository

    init(tvListingsSyncRepository: some TVListingsSyncRepository) {
        self.tvListingsSyncRepository = tvListingsSyncRepository
    }

    func execute() async throws(SyncTVListingsError) {
        do {
            try await tvListingsSyncRepository.sync()
        } catch let error {
            throw SyncTVListingsError(error)
        }
    }

}
