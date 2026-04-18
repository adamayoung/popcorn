//
//  DefaultFetchNowPlayingTVProgrammesUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchNowPlayingTVProgrammesUseCase: FetchNowPlayingTVProgrammesUseCase {

    private let tvProgrammeRepository: any TVProgrammeRepository
    private let now: @Sendable () -> Date

    init(
        tvProgrammeRepository: some TVProgrammeRepository,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.tvProgrammeRepository = tvProgrammeRepository
        self.now = now
    }

    func execute() async throws(FetchNowPlayingTVProgrammesError) -> [TVProgramme] {
        do {
            return try await tvProgrammeRepository.nowPlayingProgrammes(at: now())
        } catch let error {
            throw FetchNowPlayingTVProgrammesError(error)
        }
    }

}
