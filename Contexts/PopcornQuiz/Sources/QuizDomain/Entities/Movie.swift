//
//  Movie.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
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
