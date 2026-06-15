//
//  FetchChannelsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns the cached list of TV channels.
///
public protocol FetchChannelsUseCase: Sendable {

    func execute() async throws(FetchChannelsError) -> [Channel]

}
