//
//  MovieDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public struct MovieDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    // TODO: Make non-optional
    public let overview: String?
    public let releaseDate: Date?
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?
    public let isOnWatchlist: Bool

    public init(
        id: Int,
        title: String,
        overview: String? = nil,
        releaseDate: Date? = nil,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil,
        isOnWatchlist: Bool
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
        self.isOnWatchlist = isOnWatchlist
    }

}
