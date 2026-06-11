//
//  FetchTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns every programme across all channels within the listings time range.
///
public protocol FetchTVListingsUseCase: Sendable {

    func execute() async throws(FetchTVListingsError) -> [TVProgramme]

}
