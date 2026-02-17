//
//  Logger.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let movieDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MovieDetailsFeature"
    )

}
