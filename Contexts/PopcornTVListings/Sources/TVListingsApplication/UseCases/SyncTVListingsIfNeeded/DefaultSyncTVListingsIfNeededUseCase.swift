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

    func execute(onProgress: @Sendable @escaping (Float) -> Void) async throws(SyncTVListingsError) {
        do {
            try await tvListingsSyncRepository.syncIfNeeded(onProgress: onProgress)
        } catch let error {
            throw SyncTVListingsError(error)
        }
    }

}
