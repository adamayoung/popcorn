//
//  TVSeriesFilter.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeriesFilter: Equatable, Sendable {

    public let originalLanguage: String?
    public let genres: [Int]?

    public init(
        originalLanguage: String? = nil,
        genres: [Int]? = nil
    ) {
        self.originalLanguage = originalLanguage
        self.genres = genres
    }

}

extension TVSeriesFilter: CustomStringConvertible {

    public var description: String {
        "TVSeriesFilter(originalLanguage: \(String(describing: originalLanguage)), genres: \(String(describing: genres)))"
    }

}
