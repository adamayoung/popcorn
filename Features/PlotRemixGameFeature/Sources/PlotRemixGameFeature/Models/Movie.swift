//
//  Movie.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
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

extension Movie {

    // swiftlint:disable line_length
    static var mock: Movie {
        Movie(
            id: 118,
            title: "Charlie and the Chocolate Factory",
            overview:
            "A young boy wins a tour through the most magnificent chocolate factory in the world, led by the world's most unusual candy maker.",
            posterPath: URL(string: "/iKP6wg3c6COUe8gYutoGG7qcPnO.jpg"),
            backdropPath: URL(string: "/atoIgfAk2Ig2HFJLD0VUnjiPWEz.jpg")
        )
    }
    // swiftlint:enable line_length

}
