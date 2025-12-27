//
//  DiscoverTVSeriesRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol DiscoverTVSeriesRepository: Sendable {

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview]

}

public extension DiscoverTVSeriesRepository {

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview] {
        try await tvSeries(filter: filter, page: page, cachePolicy: .cacheFirst)
    }

}

public enum DiscoverTVSeriesRepositoryError: Error {

    case cacheUnavailable
    case unauthorised
    case unknown(Error?)

}
