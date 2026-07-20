//
//  MoviePreview.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
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

    /// Six movies so previews and snapshots exercise a full two rows of the
    /// three-across iPhone grid. Seeded from the live TMDb trending feed.
    static var mocks: [MoviePreview] {
        [
            MoviePreview(
                id: 1_368_337,
                title: "The Odyssey",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"
                )
            ),
            MoviePreview(
                id: 1_083_381,
                title: "Backrooms",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/rhGx6E3qRNMgj3i5su2oukNHwIQ.jpg"
                )
            ),
            MoviePreview(
                id: 1_339_713,
                title: "Obsession",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"
                )
            ),
            MoviePreview(
                id: 1_273_221,
                title: "Scary Movie",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/1KlYdWoOrbL5ux357rW9LC155qw.jpg"
                )
            ),
            MoviePreview(
                id: 1_228_710,
                title: "The Mandalorian and Grogu",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/5Vi8dSauVwH1HOsiZceDMbRr1Ca.jpg"
                )
            ),
            MoviePreview(
                id: 1_003_596,
                title: "Avengers: Doomsday",
                posterURL: URL(
                    string:
                    "https://image.tmdb.org/t/p/w342/cWXtJhrlruF8CeYuaBGE8vdj3Q9.jpg"
                )
            )
        ]
    }

}
