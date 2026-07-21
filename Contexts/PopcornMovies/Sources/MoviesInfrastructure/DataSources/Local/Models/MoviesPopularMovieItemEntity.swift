//
//  MoviesPopularMovieItemEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesPopularMovieItemEntity: ModelExpirable {

    var sortIndex: Int
    var page: Int
    var totalPages: Int?
    @Relationship var movie: MoviesMoviePreviewEntity?
    var cachedAt: Date

    init(
        sortIndex: Int,
        page: Int,
        totalPages: Int? = nil,
        movie: MoviesMoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.sortIndex = sortIndex
        self.page = page
        self.totalPages = totalPages
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
