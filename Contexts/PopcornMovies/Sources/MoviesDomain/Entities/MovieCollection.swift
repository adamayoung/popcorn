//
//  MovieCollection.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct MovieCollection: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(id: Int, name: String, posterPath: URL? = nil, backdropPath: URL? = nil) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
