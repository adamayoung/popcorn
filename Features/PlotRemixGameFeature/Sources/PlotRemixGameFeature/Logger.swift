//
//  Logger.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let plotRemixGame = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "PlotRemixGameFeature"
    )

}
