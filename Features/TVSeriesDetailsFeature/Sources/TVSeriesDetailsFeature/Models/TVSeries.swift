//
//  TVSeries.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct TVSeries: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?

    public init(
        id: Int,
        name: String,
        overview: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
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
            logoURL: URL(string: "https://image.tmdb.org/t/p/w500/uyVM5qGksUzCgwo6UU0UrHex8Oj.png")
        )
    }
    // swiftlint:enable line_length

}
