//
//  Movie.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Movie: Sendable, Equatable {

    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: URL?,
        backdropPath: URL?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
