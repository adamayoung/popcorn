//
//  Logger.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let discoverInfrastructure = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "DiscoverInfrastructure"
    )

}
