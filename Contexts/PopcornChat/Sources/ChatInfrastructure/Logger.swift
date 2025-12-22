//
//  Logger.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import OSLog

extension Logger {

    static let chatInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.popcorn",
        category: "ChatInfrastructure"
    )

}
