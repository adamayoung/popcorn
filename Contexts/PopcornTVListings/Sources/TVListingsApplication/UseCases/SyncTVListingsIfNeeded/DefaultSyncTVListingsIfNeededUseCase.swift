//
//  DefaultSyncTVListingsIfNeededUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultSyncTVListingsIfNeededUseCase: SyncTVListingsIfNeededUseCase {

    private let tvListingsSyncRepository: any TVListingsSyncRepository

    init(tvListingsSyncRepository: some TVListingsSyncRepository) {
        self.tvListingsSyncRepository = tvListingsSyncRepository
    }

    func execute() async throws(SyncTVListingsError) {
        do {
            try await tvListingsSyncRepository.syncIfNeeded()
        } catch let error {
            throw SyncTVListingsError(error)
        }
    }

}
