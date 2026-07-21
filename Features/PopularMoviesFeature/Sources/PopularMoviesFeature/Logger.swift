//
//  Logger.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let popularMovies = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "PopularMoviesFeature"
    )

}
