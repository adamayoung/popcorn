//
//  Logger.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import OSLog

extension Logger {

    static let intelligenceInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.popcorn",
        category: "IntelligenceInfrastructure"
    )

}
