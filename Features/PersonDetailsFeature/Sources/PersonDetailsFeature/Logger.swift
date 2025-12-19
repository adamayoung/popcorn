//
//  Logger.swift
//  PersonDetailsFeature
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let personDetails = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "PersonDetailsFeature"
    )

}
