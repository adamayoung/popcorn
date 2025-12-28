//
//  TVSeriesFilter.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines filtering criteria for selecting TV series in Plot Remix game content.
///
/// This filter combines language and genre constraints to narrow down the pool of TV
/// series for potential future game modes. Similar to ``MovieFilter``, it provides
/// consistent criteria for content selection.
///
public struct TVSeriesFilter: Equatable, Sendable {

    /// The ISO 639-1 language code to filter TV series by their original language.
    public let originalLanguage: String?

    /// The genre identifiers to filter TV series by. Multiple genres use OR logic.
    public let genres: [Int]?

    ///
    /// Creates a new TV series filter with the specified criteria.
    ///
    /// - Parameters:
    ///   - originalLanguage: The ISO 639-1 language code. Defaults to `nil` for no language filtering.
    ///   - genres: The genre identifiers to filter by. Defaults to `nil` for no genre filtering.
    ///
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
