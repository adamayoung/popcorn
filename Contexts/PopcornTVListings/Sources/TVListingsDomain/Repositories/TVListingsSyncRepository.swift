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
    /// Performs a full incremental sync: fetches the manifest, downloads only the
    /// files whose content hash has changed, and purges days no longer in the feed.
    ///
    func sync() async throws(TVListingsRepositoryError)

    ///
    /// Performs a sync only if the configured throttle interval has elapsed since the
    /// last successful sync. A no-op (no network) when called within the throttle window.
    ///
    func syncIfNeeded() async throws(TVListingsRepositoryError)

}
