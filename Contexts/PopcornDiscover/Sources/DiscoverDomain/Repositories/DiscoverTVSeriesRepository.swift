//
//  DiscoverTVSeriesRepository.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol DiscoverTVSeriesRepository: Sendable {

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview]

}

public enum DiscoverTVSeriesRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
