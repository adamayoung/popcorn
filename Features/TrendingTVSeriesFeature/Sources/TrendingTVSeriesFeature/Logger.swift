//
//  Logger.swift
//  TrendingTVSeriesFeature
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let trendingTVSeries = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "TrendingTVSeriesFeature"
    )

}
