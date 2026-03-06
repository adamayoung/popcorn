//
//  FetchTVEpisodeDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchTVEpisodeDetailsUseCase: Sendable {

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeDetailsError) -> TVEpisodeDetails

}
