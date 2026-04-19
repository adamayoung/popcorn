//
//  SyncTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Refreshes the local TV-listings cache from the remote EPG feed.
///
public protocol SyncTVListingsUseCase: Sendable {

    func execute() async throws(SyncTVListingsError)

}
