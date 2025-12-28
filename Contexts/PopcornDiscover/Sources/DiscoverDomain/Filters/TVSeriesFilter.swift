//
//  TVSeriesFilter.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents filter criteria for discovering TV series.
///
/// Use this struct to narrow down TV series discovery results by language
/// or genre.
///
public struct TVSeriesFilter: Equatable, Sendable {

    /// The ISO 639-1 language code to filter by (e.g., "en", "es").
    public let originalLanguage: String?

    /// Array of genre IDs to filter by.
    public let genres: [Int]?

    ///
    /// Creates a new TV series filter with the specified criteria.
    ///
    /// - Parameters:
    ///   - originalLanguage: The ISO 639-1 language code to filter by. Defaults to `nil`.
    ///   - genres: Array of genre IDs to filter by. Defaults to `nil`.
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

    /// A textual representation of the TV series filter for debugging purposes.
    public var description: String {
        "TVSeriesFilter(originalLanguage: \(String(describing: originalLanguage)), genres: \(String(describing: genres)))"
    }

}
