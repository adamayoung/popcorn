//
//  MoviesSimilarMovieItemEntity.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesSimilarMovieItemEntity: ModelExpirable {

    var movieID: Int
    var sortIndex: Int
    var page: Int
    @Relationship var movie: MoviesMoviePreviewEntity?
    var cachedAt: Date

    init(
        movieID: Int,
        sortIndex: Int,
        page: Int,
        movie: MoviesMoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.sortIndex = sortIndex
        self.page = page
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
