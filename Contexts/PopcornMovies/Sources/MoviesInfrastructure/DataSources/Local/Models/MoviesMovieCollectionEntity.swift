//
//  MoviesMovieCollectionEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesMovieCollectionEntity: Equatable {

    var collectionID: Int
    var name: String
    var posterPath: URL?
    var backdropPath: URL?
    @Relationship(inverse: \MoviesMovieEntity.belongsToCollection) var movie: MoviesMovieEntity?

    init(collectionID: Int, name: String, posterPath: URL? = nil, backdropPath: URL? = nil) {
        self.collectionID = collectionID
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
