//
//  DefaultFetchTVListingsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVListingsUseCase: FetchTVListingsUseCase {

    /// Default look-ahead window: the next 24 hours.
    static let defaultWindow: TimeInterval = 24 * 60 * 60

    private let tvProgrammeRepository: any TVProgrammeRepository
    private let now: @Sendable () -> Date
    private let window: TimeInterval

    init(
        tvProgrammeRepository: some TVProgrammeRepository,
        now: @escaping @Sendable () -> Date = { .now },
        window: TimeInterval = DefaultFetchTVListingsUseCase.defaultWindow
    ) {
        self.tvProgrammeRepository = tvProgrammeRepository
        self.now = now
        self.window = window
    }

    func execute() async throws(FetchTVListingsError) -> [TVProgramme] {
        let start = now()
        let end = start.addingTimeInterval(window)
        do {
            return try await tvProgrammeRepository.programmes(from: start, to: end)
        } catch let error {
            throw FetchTVListingsError(error)
        }
    }

}
