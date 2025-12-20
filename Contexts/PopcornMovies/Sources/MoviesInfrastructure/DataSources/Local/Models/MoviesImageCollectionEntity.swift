//
//  MoviesImageCollectionEntity.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesImageCollectionEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var movieID: Int
    var posterPaths: [URL]
    var backdropPaths: [URL]
    var logoPaths: [URL]
    var cachedAt: Date

    init(
        movieID: Int,
        posterPaths: [URL] = [],
        backdropPaths: [URL] = [],
        logoPaths: [URL] = [],
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.posterPaths = posterPaths
        self.backdropPaths = backdropPaths
        self.logoPaths = logoPaths
        self.cachedAt = cachedAt
    }

}
