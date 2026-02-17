//
//  MoviePreview.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct MoviePreview: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let title: String
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?

    public init(
        id: Int,
        title: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
    }

}

extension MoviePreview {

    static var mocks: [MoviePreview] {
        [
            MoviePreview(
                id: 798_645,
                title: "The Running Man",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w780/dKL78O9zxczVgjtNcQ9UkbYLzqX.jpg"
                ),
                backdropURL: URL(
                    string: "https://image.tmdb.org/t/p/w1280/docDyCJrhPoFXAckB1aOiIv9Mz0.jpg"
                ),
                logoURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/qVFenxaKbLr76dSJN5qRMM82X2u.png"
                )
            ),
            MoviePreview(
                id: 1_197_137,
                title: "Black Phone 2",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w780/xUWUODKPIilQoFUzjHM6wKJkP3Y.jpg"
                ),
                backdropURL: URL(
                    string: "https://image.tmdb.org/t/p/w1280/6zKjoOOb3OZnZuiHtQZn4Kd69Gq.jpg"
                ),
                logoURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/edPw35KtvaP8mJNtujFNsbPCmJV.png"
                )
            )
        ]
    }

}
