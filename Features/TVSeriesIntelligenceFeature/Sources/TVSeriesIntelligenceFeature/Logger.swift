//
//  Logger.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import OSLog

extension Logger {

    static let tvSeriesIntelligence = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "tvSeriesIntelligence"
    )

}
