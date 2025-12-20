//
//  MovieFilter.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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

    public var dictionary: [String: String] {
        [
            "original_language": originalLanguage ?? "nil",
            "genre_ids": genres?.map(String.init).joined(separator: ", ") ?? "nil",
            "primary_release_year": primaryReleaseYear?.description ?? "nil"
        ]
    }

}

public extension MovieFilter.PrimaryReleaseYearFilter {

    var description: String {
        switch self {
        case .onYear(let year): "onYear(\(year))"
        case .fromYear(let year): "fromYear(\(year))"
        case .upToYear(let year): "upToYear(\(year))"
        case .betweenYears(let start, let end): "betweenYears(start: \(start), end: \(end))"
        }
    }

}
