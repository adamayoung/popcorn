//
//  DefaultFetchTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVListingsUseCase: FetchTVListingsUseCase {

    private let tvProgrammeRepository: any TVProgrammeRepository
    private let now: @Sendable () -> Date
    private let daysAhead: Int

    init(
        tvProgrammeRepository: some TVProgrammeRepository,
        now: @escaping @Sendable () -> Date = { .now },
        daysAhead: Int = 3
    ) {
        self.tvProgrammeRepository = tvProgrammeRepository
        self.now = now
        self.daysAhead = daysAhead
    }

    func execute() async throws(FetchTVListingsError) -> [TVProgramme] {
        let start = now()
        let end = start.addingTimeInterval(Double(daysAhead) * 86400)
        do {
            return try await tvProgrammeRepository.programmes(from: start, to: end)
        } catch let error {
            throw FetchTVListingsError(error)
        }
    }

}
