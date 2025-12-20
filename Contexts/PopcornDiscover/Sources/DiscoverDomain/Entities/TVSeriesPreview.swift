//
//  TVSeriesPreview.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let firstAirDate: Date
    public let genreIDs: [Int]
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        name: String,
        overview: String,
        firstAirDate: Date,
        genreIDs: [Int],
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
