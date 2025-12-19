//
//  Logger.swift
//  PopcornMovies
//
//  Created by Adam Young on 19/12/2025.
//

import Foundation
import OSLog

extension Logger {

    static let moviesApplication = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.unknown.Popcorn",
        category: "MoviesApplication"
    )

}
