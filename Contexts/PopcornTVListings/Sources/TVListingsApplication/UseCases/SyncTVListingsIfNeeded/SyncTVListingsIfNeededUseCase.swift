//
//  SyncTVListingsIfNeededUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Refreshes the local TV-listings cache only when the sync throttle interval has
/// elapsed since the last successful sync. A no-op (no network) within that window.
///
public protocol SyncTVListingsIfNeededUseCase: Sendable {

    /// - Parameter onProgress: Reports sync completion as a fraction in `0...1`, weighted by
    ///   the files to download. Not called for a throttled no-op.
    func execute(onProgress: @Sendable @escaping (Float) -> Void) async throws(SyncTVListingsError)

}

public extension SyncTVListingsIfNeededUseCase {

    /// Convenience that syncs without observing progress.
    func execute() async throws(SyncTVListingsError) {
        try await execute(onProgress: { _ in })
    }

}
