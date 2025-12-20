//
//  Logger.swift
//  FeatureAccessAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let featureFlags = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "FeatureAccessAdapters"
    )

}
