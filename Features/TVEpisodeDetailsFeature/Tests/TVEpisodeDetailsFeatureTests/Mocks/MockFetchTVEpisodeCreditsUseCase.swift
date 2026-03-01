//
//  MockFetchTVEpisodeCreditsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct MockFetchTVEpisodeCreditsUseCase: FetchTVEpisodeCreditsUseCase {

    let credits: TVSeriesApplication.CreditsDetails?

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeCreditsError) -> TVSeriesApplication.CreditsDetails {
        guard let credits else {
            throw .notFound
        }
        return credits
    }

}
