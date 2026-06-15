//
//  FetchTVRegionsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns the cached list of TV regions.
///
public protocol FetchTVRegionsUseCase: Sendable {

    func execute() async throws(FetchTVRegionsError) -> [TVRegion]

}
