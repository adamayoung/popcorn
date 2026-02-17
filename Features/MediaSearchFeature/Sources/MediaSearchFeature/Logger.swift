//
//  Logger.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let mediaSearch = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MediaSearchFeature"
    )

}
