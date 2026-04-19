//
//  DefaultFetchTVChannelScheduleUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVChannelScheduleUseCase: FetchTVChannelScheduleUseCase {

    private let tvProgrammeRepository: any TVProgrammeRepository

    init(tvProgrammeRepository: some TVProgrammeRepository) {
        self.tvProgrammeRepository = tvProgrammeRepository
    }

    func execute(
        channelID: String,
        date: Date
    ) async throws(FetchTVChannelScheduleError) -> [TVProgramme] {
        do {
            return try await tvProgrammeRepository.programmes(forChannelID: channelID, onDate: date)
        } catch let error {
            throw FetchTVChannelScheduleError(error)
        }
    }

}
