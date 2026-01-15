//
//  MovieDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

public struct MovieDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let tagline: String?
    public let overview: String
    public let runtime: Int?
    public let genres: [Genre]?
    public let releaseDate: Date?
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?
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
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil,
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
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.isOnWatchlist = isOnWatchlist
    }

}
