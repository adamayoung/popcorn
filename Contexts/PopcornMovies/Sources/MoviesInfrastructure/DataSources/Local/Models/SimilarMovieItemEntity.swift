//
//  SimilarMovieItemEntity.swift
//  PopcornMovies
//
//  Created by Adam Young on 10/11/2025.
//

import Foundation
import SwiftData

@Model
final class SimilarMovieItemEntity: ModelExpirable {

    var movieID: Int
    var sortIndex: Int
    var page: Int
    @Relationship var movie: MoviePreviewEntity?
    var cachedAt: Date

    init(
        movieID: Int,
        sortIndex: Int,
        page: Int,
        movie: MoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.sortIndex = sortIndex
        self.page = page
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
