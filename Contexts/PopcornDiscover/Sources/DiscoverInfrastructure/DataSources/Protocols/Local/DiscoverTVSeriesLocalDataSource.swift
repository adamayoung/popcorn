//
//  DiscoverTVSeriesLocalDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

public protocol DiscoverTVSeriesLocalDataSource: Sendable, Actor {

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> [TVSeriesPreview]?

    func tvSeriesStream(
        filter: TVSeriesFilter?
    ) async -> AsyncThrowingStream<[TVSeriesPreview]?, Error>

    func currentTVSeriesStreamPage(
        filter: TVSeriesFilter?
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> Int?

    func setTVSeries(
        _ tvSeriesPreviews: [TVSeriesPreview],
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError)

}

public enum DiscoverTVSeriesLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
