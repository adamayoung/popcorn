//
//  MoviesMovieCertificationEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesMovieCertificationEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var movieID: Int
    var certification: String
    var cachedAt: Date

    init(
        movieID: Int,
        certification: String,
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.certification = certification
        self.cachedAt = cachedAt
    }

}
