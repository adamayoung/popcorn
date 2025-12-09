//
//  DiscoverTVSeriesRepository.swift
//  PopcornDiscover
//
//  Created by Adam Young on 28/05/2025.
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
