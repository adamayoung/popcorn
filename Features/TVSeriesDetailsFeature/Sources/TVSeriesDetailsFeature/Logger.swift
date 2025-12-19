//
//  Logger.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let tvSeriesDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "TVSeriesDetailsFeature"
    )

}
