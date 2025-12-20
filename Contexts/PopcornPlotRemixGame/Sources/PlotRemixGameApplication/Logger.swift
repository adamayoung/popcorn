//
//  Logger.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

extension Logger {

    static let plotRemixGameApplication = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "PlotRemixGameApplication"
    )

}
