//
//  Movie.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import Foundation

public struct Movie: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let title: String
    public let overview: String
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?
    public let isFavourite: Bool

    public init(
        id: Int,
        title: String,
        overview: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil,
        isFavourite: Bool
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
        self.isFavourite = isFavourite
    }

}

extension Movie {

    static var mock: Movie {
        Movie(
            id: 798645,
            title: "The Running Man",
            overview:
                "Desperate to save his sick daughter, working-class Ben Richards is convinced by The Running Man's charming but ruthless producer to enter the deadly competition game as a last resort. But Ben's defiance, instincts, and grit turn him into an unexpected fan favorite - and a threat to the entire system. As ratings skyrocket, so does the danger, and Ben must outwit not just the Hunters, but a nation addicted to watching him fall.",
            posterURL: URL(
                string: "https://image.tmdb.org/t/p/w780/dKL78O9zxczVgjtNcQ9UkbYLzqX.jpg"),
            backdropURL: URL(
                string: "https://image.tmdb.org/t/p/w1280/docDyCJrhPoFXAckB1aOiIv9Mz0.jpg"),
            logoURL: URL(string: "https://image.tmdb.org/t/p/w500/qVFenxaKbLr76dSJN5qRMM82X2u.png"),
            isFavourite: false
        )
    }

}
