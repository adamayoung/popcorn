//
//  TVSeriesDetailsTool.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import TVSeriesDomain

/// A tool that provides detailed information about a specific TV series
public struct TVSeriesDetailsTool: Tool {

    public let name = "getTVSeriesDetails"
    public let description = "Fetch detailed information about the current TV series including name and overview"

    @Generable
    public struct Arguments {
        public init() {}
    }

    private let tvSeriesID: Int
    private let tvSeriesRepository: any TVSeriesRepository

    public init(tvSeriesID: Int, tvSeriesRepository: any TVSeriesRepository) {
        self.tvSeriesID = tvSeriesID
        self.tvSeriesRepository = tvSeriesRepository
    }

    public func call(arguments: Arguments) async throws -> String {
        let tvSeries = try await tvSeriesRepository.tvSeries(withID: tvSeriesID)

        let overview = tvSeries.overview ?? "No overview available"

        return """
        Name: \(tvSeries.name)
        Overview: \(overview)
        """
    }

}
