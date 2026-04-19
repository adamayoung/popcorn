//
//  FetchTVChannelScheduleUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Returns the programmes scheduled on a given channel for a given UK-local calendar day.
///
public protocol FetchTVChannelScheduleUseCase: Sendable {

    func execute(
        channelID: String,
        date: Date
    ) async throws(FetchTVChannelScheduleError) -> [TVProgramme]

}
