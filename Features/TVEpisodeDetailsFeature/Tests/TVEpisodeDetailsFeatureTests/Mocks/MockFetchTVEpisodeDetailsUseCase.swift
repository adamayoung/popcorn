//
//  MockFetchTVEpisodeDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct MockFetchTVEpisodeDetailsUseCase: FetchTVEpisodeDetailsUseCase {

    let episodeDetails: TVSeriesApplication.TVEpisodeSummary?

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeDetailsError) -> TVSeriesApplication.TVEpisodeSummary {
        guard let episodeDetails else {
            throw .notFound
        }
        return episodeDetails
    }

}
