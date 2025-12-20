//
//  Logger.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let explore = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "ExploreFeature"
    )

}
