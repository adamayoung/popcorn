//
//  Logger.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let movieIntelligence = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MovieIntelligenceFeature"
    )

}
