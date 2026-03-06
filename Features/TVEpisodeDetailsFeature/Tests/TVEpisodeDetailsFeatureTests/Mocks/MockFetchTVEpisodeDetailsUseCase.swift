//
//  MockFetchTVEpisodeDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct MockFetchTVEpisodeDetailsUseCase: FetchTVEpisodeDetailsUseCase {

    let episodeDetails: TVSeriesApplication.TVEpisodeDetails?

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeDetailsError) -> TVSeriesApplication.TVEpisodeDetails {
        guard let episodeDetails else {
            throw .notFound
        }
        return episodeDetails
    }

}
