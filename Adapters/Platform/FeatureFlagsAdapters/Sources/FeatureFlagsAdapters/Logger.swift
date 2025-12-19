//
//  Logger.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let featureFlags = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "FeatureFlagsAdapters"
    )

}
