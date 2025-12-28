//
//  Logger.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import OSLog

extension Logger {

    static let intelligenceInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.popcorn",
        category: "IntelligenceInfrastructure"
    )

}
