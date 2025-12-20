//
//  Logger.swift
//  PersonDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let personDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "PersonDetailsFeature"
    )

}
