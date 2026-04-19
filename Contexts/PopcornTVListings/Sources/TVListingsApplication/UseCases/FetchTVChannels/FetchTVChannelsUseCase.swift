//
//  FetchTVChannelsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns the cached list of TV channels.
///
public protocol FetchTVChannelsUseCase: Sendable {

    func execute() async throws(FetchTVChannelsError) -> [TVChannel]

}
