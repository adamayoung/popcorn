//
//  Logger.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let trendingPeople = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TrendingPeopleFeature"
    )

}
