//
//  Logger.swift
//  FeatureAccessAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    ///
    /// A logger instance for feature flags related logging.
    ///
    static let featureFlags = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "FeatureAccessAdapters"
    )

}
