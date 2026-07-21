//
//  Logger.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let discoverMovies = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "DiscoverMoviesFeature"
    )

}
