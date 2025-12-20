//
//  Logger.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let moviesApplication = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MoviesApplication"
    )

}
