//
//  MoviePreview.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct MoviePreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: Date?
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
