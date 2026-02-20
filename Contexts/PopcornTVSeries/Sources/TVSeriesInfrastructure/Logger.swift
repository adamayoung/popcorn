//
//  Logger.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let tvSeriesInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TVSeriesInfrastructure"
    )

}
