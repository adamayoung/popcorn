//
//  Logger.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let trendingTVSeries = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TrendingTVSeriesFeature"
    )

}
