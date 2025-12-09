//
//  MoviePreview.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
//

import Foundation

public struct MoviePreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: Date
    public let genreIDs: [Int]
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date,
        genreIDs: [Int],
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
