//
//  TVSeason.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeason: Equatable, Sendable {

    public let id: Int
    public let seasonNumber: Int
    public let tvSeriesID: Int
    public let name: String
    public let tvSeriesName: String
    public let posterURL: URL?
    public let overview: String?

}

extension TVSeason {

    static var mock: TVSeason {
        TVSeason(
            id: 1,
            seasonNumber: 1,
            tvSeriesID: 1396,
            name: "Season 1",
            tvSeriesName: "Breaking Bad",
            posterURL: URL(
                string: "https://image.tmdb.org/t/p/w185/1BP4xYv9ZG4ZVHkL7ocOziBbSYH.jpg"
            ),
            overview: "High school chemistry teacher Walter White's life is suddenly transformed by "
                + "a dire medical diagnosis. Street-savvy former student Jesse Pinkman \"teaches\" "
                + "Walter a new trade."
        )
    }

}
