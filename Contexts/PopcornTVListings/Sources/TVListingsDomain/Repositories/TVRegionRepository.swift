//
//  TVRegionRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides read access to the locally cached list of TV regions.
///
public protocol TVRegionRepository: Sendable {

    func regions() async throws(TVListingsRepositoryError) -> [TVRegion]

}
