//
//  MoviesGenreEntity.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesGenreEntity: Equatable {

    var genreID: Int
    var name: String

    init(genreID: Int, name: String) {
        self.genreID = genreID
        self.name = name
    }

}
