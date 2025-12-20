//
//  MovieFilter.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct MovieFilter: Equatable, Sendable {

    public let originalLanguage: String?
    public let genres: [Int]?
    public let primaryReleaseYear: PrimaryReleaseYearFilter

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
