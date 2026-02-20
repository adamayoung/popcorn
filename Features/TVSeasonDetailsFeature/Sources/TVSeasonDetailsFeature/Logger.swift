//
//  Logger.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let tvSeasonDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TVSeasonDetailsFeature"
    )

}
