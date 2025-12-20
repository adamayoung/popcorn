//
//  MoviesPopularMovieItemEntity.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesPopularMovieItemEntity: ModelExpirable {

    var sortIndex: Int
    var page: Int
    @Relationship var movie: MoviesMoviePreviewEntity?
    var cachedAt: Date

    init(
        sortIndex: Int,
        page: Int,
        movie: MoviesMoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.sortIndex = sortIndex
        self.page = page
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
