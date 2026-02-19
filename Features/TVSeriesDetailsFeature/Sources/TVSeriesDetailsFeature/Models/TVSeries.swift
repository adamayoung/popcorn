//
//  TVSeries.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeries: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?
    public let seasons: [TVSeasonPreview]

    public init(
        id: Int,
        name: String,
        overview: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil,
        seasons: [TVSeasonPreview] = []
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
        self.seasons = seasons
    }

}

extension TVSeries {

    // swiftlint:disable line_length
    static var mock: TVSeries {
        TVSeries(
            id: 66732,
            name: "Stranger Things",
            overview:
            "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            posterURL: URL(
                string: "https://image.tmdb.org/t/p/w780/cVxVGwHce6xnW8UaVUggaPXbmoE.jpg"
            ),
            backdropURL: URL(
                string: "https://image.tmdb.org/t/p/w1280/56v2KjBlU4XaOv9rVYEQypROD7P.jpg"
            ),
            logoURL: URL(string: "https://image.tmdb.org/t/p/w500/uyVM5qGksUzCgwo6UU0UrHex8Oj.png"),
            seasons: [
                TVSeasonPreview(
                    id: 77680,
                    seasonNumber: 1,
                    name: "Season 1",
                    posterURL: URL(string: "https://image.tmdb.org/t/p/w780/fOaUnQwDJV22esXEswhaDMSqn2w.jpg")
                ),
                TVSeasonPreview(
                    id: 83248,
                    seasonNumber: 2,
                    name: "Stranger Things 2",
                    posterURL: URL(string: "https://image.tmdb.org/t/p/w780/74nFJmiapxKuUBXRbSu6VqGGcuo.jpg")
                ),
                TVSeasonPreview(
                    id: 96710,
                    seasonNumber: 3,
                    name: "Stranger Things 3",
                    posterURL: URL(string: "https://image.tmdb.org/t/p/w780/cfsvLCFv3Axm0DdBfg2GRXP6kes.jpg")
                ),
                TVSeasonPreview(
                    id: 131_987,
                    seasonNumber: 4,
                    name: "Stranger Things 4",
                    posterURL: URL(string: "https://image.tmdb.org/t/p/w780/49WJfeN0moxb9IPfGn8AIqMGskD.jpg")
                )
            ]
        )
    }
    // swiftlint:enable line_length

}
