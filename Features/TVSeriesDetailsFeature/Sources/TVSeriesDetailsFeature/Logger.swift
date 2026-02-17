//
//  Logger.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let tvSeriesDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TVSeriesDetailsFeature"
    )

}
