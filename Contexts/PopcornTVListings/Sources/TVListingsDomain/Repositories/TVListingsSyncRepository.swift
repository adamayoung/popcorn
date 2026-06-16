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
    /// - Parameter onProgress: Reports completion of the sync as a fraction in `0...1`,
    ///   weighted by the number of files to download. Called zero times for a throttled
    ///   no-op. When triggers coalesce onto an in-flight sync, progress is reported only
    ///   to the caller that started the run; coalescing callers receive none.
    ///
    func syncIfNeeded(onProgress: @Sendable @escaping (Float) -> Void) async throws(TVListingsRepositoryError)

}

public extension TVListingsSyncRepository {

    /// Convenience that syncs without observing progress.
    func syncIfNeeded() async throws(TVListingsRepositoryError) {
        try await syncIfNeeded(onProgress: { _ in })
    }

}
