//
//  TVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Orchestrates fetching the remote EPG manifest and incrementally updating the local cache.
///
public protocol TVListingsSyncRepository: Sendable {

    ///
    /// Performs a sync only if the configured throttle interval has elapsed since the
    /// last successful sync. A no-op (no network) when called within the throttle window.
    /// This is the only entry point used by the app; the unconditional sync is an
    /// implementation detail of the concrete repository.
    ///
    func syncIfNeeded() async throws(TVListingsRepositoryError)

}
