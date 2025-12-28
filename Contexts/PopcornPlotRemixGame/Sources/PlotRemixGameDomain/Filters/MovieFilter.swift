//
//  MovieFilter.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines filtering criteria for selecting movies in Plot Remix game question generation.
///
/// This filter combines language, genre, and release year constraints to narrow down the
/// pool of movies used for game questions. Filters ensure questions are tailored to player
/// preferences and create a consistent difficulty level within a game session.
///
public struct MovieFilter: Equatable, Sendable {

    /// The ISO 639-1 language code to filter movies by their original language.
    public let originalLanguage: String?

    /// The genre identifiers to filter movies by. Multiple genres use OR logic.
    public let genres: [Int]?

    /// The release year constraints for movie selection.
    public let primaryReleaseYear: PrimaryReleaseYearFilter

    ///
    /// Creates a new movie filter with the specified criteria.
    ///
    /// - Parameters:
    ///   - originalLanguage: The ISO 639-1 language code. Defaults to `nil` for no language filtering.
    ///   - genres: The genre identifiers to filter by. Defaults to `nil` for no genre filtering.
    ///   - primaryReleaseYear: The release year constraints.
    ///
    public init(
        originalLanguage: String? = nil,
        genres: [Int]? = nil,
        primaryReleaseYear: PrimaryReleaseYearFilter
    ) {
        self.originalLanguage = originalLanguage
        self.genres = genres
        self.primaryReleaseYear = primaryReleaseYear
    }

}

extension MovieFilter: CustomStringConvertible {

    public var description: String {
        "MovieFilter(originalLanguage: \(String(describing: originalLanguage)), genres: \(String(describing: genres)), primaryReleaseYear: \(String(describing: primaryReleaseYear)))"
    }

}

public extension MovieFilter {

    ///
    /// Creates a movie filter from a game configuration.
    ///
    /// Extracts genre and release year filters from the configuration, applying default
    /// values when the configuration does not specify constraints. Defaults to English
    /// language films from 1980-2025 when no year filter is provided.
    ///
    /// - Parameter config: The game configuration to derive filter criteria from.
    ///
    init(config: GameConfig) {
        let genreIDs: [Int]? = {
            guard let genreID = config.genreID else {
                return nil
            }

            return [genreID]
        }()

        let primaryReleaseYearFilter: PrimaryReleaseYearFilter = {
            guard let primaryReleaseYearFilter = config.primaryReleaseYearFilter else {
                return .betweenYears(start: 1980, end: 2025)
            }

            return primaryReleaseYearFilter
        }()

        self.init(
            originalLanguage: "en",
            genres: genreIDs,
            primaryReleaseYear: primaryReleaseYearFilter
        )
    }

}
