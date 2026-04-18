//
//  TVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Orchestrates fetching the remote EPG snapshot and replacing the local cache.
///
public protocol TVListingsSyncRepository: Sendable {

    func sync() async throws(TVListingsRepositoryError)

}
