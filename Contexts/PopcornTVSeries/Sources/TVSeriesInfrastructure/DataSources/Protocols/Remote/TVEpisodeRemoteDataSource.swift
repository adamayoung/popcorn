//
//  TVEpisodeRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVEpisodeRemoteDataSource: Sendable {

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRemoteDataSourceError) -> TVEpisode

}

public enum TVEpisodeRemoteDataSourceError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
