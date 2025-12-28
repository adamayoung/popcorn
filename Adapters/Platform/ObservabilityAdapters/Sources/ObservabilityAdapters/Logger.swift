//
//  Logger.swift
//  ObservabilityAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    ///
    /// A logger instance for observability related logging.
    ///
    static let observability = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "ObservabilityAdapters"
    )

}
