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

    func execute() async throws(SyncTVListingsError)

}
