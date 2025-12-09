//
//  MovieFilter.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
//

import Foundation

public struct MovieFilter: Equatable, Sendable {

    public enum PrimaryReleaseYearFilter: Equatable, Sendable {
        case onYear(Int)
        case fromYear(Int)
        case upToYear(Int)
        case betweenYears(start: Int, end: Int)
    }

    public let originalLanguage: String?
    public let genres: [Int]?
    public let primaryReleaseYear: PrimaryReleaseYearFilter?

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

    public var description: String {
        "MovieFilter(originalLanguage: \(String(describing: originalLanguage)), genres: \(String(describing: genres)), primaryReleaseYear: \(String(describing: primaryReleaseYear)))"
    }

}
