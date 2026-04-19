//
//  FetchNowPlayingTVProgrammesUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns the programme currently airing on each channel at the current time.
///
public protocol FetchNowPlayingTVProgrammesUseCase: Sendable {

    func execute() async throws(FetchNowPlayingTVProgrammesError) -> [TVProgramme]

}
