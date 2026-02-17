//
//  Logger.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let moviesInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MoviesInfrastructure"
    )

}
