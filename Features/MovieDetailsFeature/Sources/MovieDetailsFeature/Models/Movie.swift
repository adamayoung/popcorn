//
//  Movie.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Movie: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let title: String
    public let tagline: String?
    public let overview: String
    public let runtime: Int?
    public let genres: [Genre]?
    public let releaseDate: Date?
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?
    public let budget: Double?
    public let revenue: Double?
    public let homepageURL: URL?
    public let isOnWatchlist: Bool

    public init(
        id: Int,
        title: String,
        tagline: String? = nil,
        overview: String,
        runtime: Int? = nil,
        genres: [Genre]? = nil,
        releaseDate: Date? = nil,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        isOnWatchlist: Bool
    ) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.overview = overview
        self.runtime = runtime
        self.genres = genres
        self.releaseDate = releaseDate
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.isOnWatchlist = isOnWatchlist
    }

}

extension Movie {

    // swiftlint:disable line_length
    static var mock: Movie {
        Movie(
            id: 798_645,
            title: "The Running Man",
            tagline: "The race for survival begins.",
            overview:
            "Desperate to save his sick daughter, working-class Ben Richards is convinced by The Running Man's charming but ruthless producer to enter the deadly competition game as a last resort. But Ben's defiance, instincts, and grit turn him into an unexpected fan favorite - and a threat to the entire system. As ratings skyrocket, so does the danger, and Ben must outwit not just the Hunters, but a nation addicted to watching him fall.",
            runtime: 120,
            genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 53, name: "Thriller")
            ],
            releaseDate: Date(timeIntervalSince1970: 1_748_390_400),
            posterURL: URL(
                string: "https://image.tmdb.org/t/p/w780/dKL78O9zxczVgjtNcQ9UkbYLzqX.jpg"),
            backdropURL: URL(
                string: "https://image.tmdb.org/t/p/w1280/docDyCJrhPoFXAckB1aOiIv9Mz0.jpg"),
            logoURL: URL(string: "https://image.tmdb.org/t/p/w500/qVFenxaKbLr76dSJN5qRMM82X2u.png"),
            budget: 100_000_000,
            revenue: 250_000_000,
            homepageURL: URL(string: "https://www.runningmanmovie.com"),
            isOnWatchlist: false
        )
    }
    // swiftlint:enable line_length

}
