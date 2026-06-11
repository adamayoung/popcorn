//
//  SyncTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Unconditionally refreshes the local TV-listings cache from the remote EPG feed,
/// bypassing the 12h throttle. Retained as the forced-sync primitive that
/// ``SyncTVListingsIfNeededUseCase`` is the throttled counterpart to; automatic sync
/// uses the throttled variant, so this currently has no production caller.
///
public protocol SyncTVListingsUseCase: Sendable {

    func execute() async throws(SyncTVListingsError)

}
