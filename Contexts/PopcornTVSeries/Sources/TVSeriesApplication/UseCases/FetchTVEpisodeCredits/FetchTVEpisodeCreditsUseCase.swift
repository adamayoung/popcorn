//
//  FetchTVEpisodeCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVEpisodeCreditsUseCase: Sendable {

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeCreditsError) -> CreditsDetails

}
