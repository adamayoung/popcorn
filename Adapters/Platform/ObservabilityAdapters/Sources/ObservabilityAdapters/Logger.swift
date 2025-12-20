//
//  Logger.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let observability = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "ObservabilityAdapters"
    )

}
