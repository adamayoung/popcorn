//
//  TVSeriesChatToolsProvider.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

/// Provider for TV series chat tools
public struct TVSeriesChatToolsProvider: TVSeriesChatToolsProviding {

    private let tvSeriesRepository: any TVSeriesRepository

    /// Creates a new TV series chat tools provider
    /// - Parameter tvSeriesRepository: Repository for fetching TV series details and images
    public init(tvSeriesRepository: any TVSeriesRepository) {
        self.tvSeriesRepository = tvSeriesRepository
    }

    public func tools(for tvSeriesID: Int) -> [any Sendable] {
        [
            TVSeriesDetailsTool(tvSeriesID: tvSeriesID, tvSeriesRepository: tvSeriesRepository),
            TVSeriesImagesTool(tvSeriesID: tvSeriesID, tvSeriesRepository: tvSeriesRepository)
        ]
    }

}
