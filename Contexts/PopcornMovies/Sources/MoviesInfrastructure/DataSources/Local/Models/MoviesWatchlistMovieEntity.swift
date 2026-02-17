//
//  MoviesWatchlistMovieEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesWatchlistMovieEntity: Equatable, Identifiable {

    var movieID: Int?
    var createdAt: Date?

    init(
        movieID: Int,
        createdAt: Date
    ) {
        self.movieID = movieID
        self.createdAt = createdAt
    }

}
