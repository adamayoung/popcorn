//
//  MoviesWatchlistMovieEntity.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
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
