//
//  TVEpisodeCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol TVEpisodeCreditsRepository: Sendable {

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsRepositoryError) -> Credits

}

public enum TVEpisodeCreditsRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
