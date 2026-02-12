//
//  MoviePreview.swift
//  TrendingMoviesFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct MoviePreview: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let title: String
    public let posterURL: URL?

    public init(
        id: Int,
        title: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
    }

}

extension MoviePreview {

    static var mocks: [MoviePreview] {
        [
            MoviePreview(
                id: 1,
                title: "The Running Man",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w780/dKL78O9zxczVgjtNcQ9UkbYLzqX.jpg"
                )
            ),
            MoviePreview(
                id: 2,
                title: "Black Phone 2",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w780/xUWUODKPIilQoFUzjHM6wKJkP3Y.jpg"
                )
            )
        ]
    }

}
