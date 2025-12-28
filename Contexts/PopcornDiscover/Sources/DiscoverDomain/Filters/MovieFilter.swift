//
//  MovieFilter.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents filter criteria for discovering movies.
///
/// Use this struct to narrow down movie discovery results by language,
/// genre, or release year.
///
public struct MovieFilter: Equatable, Sendable {

    ///
    /// Defines how to filter movies by their primary release year.
    ///
    public enum PrimaryReleaseYearFilter: Equatable, Sendable {

        /// Movies released in the specified year only.
        case onYear(Int)

        /// Movies released from the specified year onwards.
        case fromYear(Int)

        /// Movies released up to and including the specified year.
        case upToYear(Int)

        /// Movies released between the start and end years (inclusive).
        case betweenYears(start: Int, end: Int)
    }

    /// The ISO 639-1 language code to filter by (e.g., "en", "es").
    public let originalLanguage: String?

    /// Array of genre IDs to filter by.
    public let genres: [Int]?

    /// Filter for the movie's primary release year.
    public let primaryReleaseYear: PrimaryReleaseYearFilter?

    ///
    /// Creates a new movie filter with the specified criteria.
    ///
    /// - Parameters:
    ///   - originalLanguage: The ISO 639-1 language code to filter by. Defaults to `nil`.
    ///   - genres: Array of genre IDs to filter by. Defaults to `nil`.
    ///   - primaryReleaseYear: Filter for the release year. Defaults to `nil`.
    ///
    public init(
        originalLanguage: String? = nil,
        genres: [Int]? = nil,
        primaryReleaseYear: PrimaryReleaseYearFilter? = nil
    ) {
        self.originalLanguage = originalLanguage
        self.genres = genres
        self.primaryReleaseYear = primaryReleaseYear
    }

}

extension MovieFilter: CustomStringConvertible {

    /// A textual representation of the movie filter for debugging purposes.
    public var description: String {
        "MovieFilter(originalLanguage: \(String(describing: originalLanguage)), genres: \(String(describing: genres)), primaryReleaseYear: \(String(describing: primaryReleaseYear)))"
    }

    /// A dictionary representation of the filter criteria for logging or analytics.
    public var dictionary: [String: String] {
        [
            "original_language": originalLanguage ?? "nil",
            "genre_ids": genres?.map(String.init).joined(separator: ", ") ?? "nil",
            "primary_release_year": primaryReleaseYear?.description ?? "nil"
        ]
    }

}

public extension MovieFilter.PrimaryReleaseYearFilter {

    /// A textual representation of the release year filter for debugging purposes.
    var description: String {
        switch self {
        case .onYear(let year): "onYear(\(year))"
        case .fromYear(let year): "fromYear(\(year))"
        case .upToYear(let year): "upToYear(\(year))"
        case .betweenYears(let start, let end): "betweenYears(start: \(start), end: \(end))"
        }
    }

}
