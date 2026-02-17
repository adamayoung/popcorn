//
//  MoviesSpokenLanguageEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesSpokenLanguageEntity: Equatable {

    var languageCode: String
    var name: String
    @Relationship(inverse: \MoviesMovieEntity.spokenLanguages) var movie: MoviesMovieEntity?

    init(languageCode: String, name: String) {
        self.languageCode = languageCode
        self.name = name
    }

}
