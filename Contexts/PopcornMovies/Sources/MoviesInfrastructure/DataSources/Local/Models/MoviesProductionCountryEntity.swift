//
//  MoviesProductionCountryEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesProductionCountryEntity: Equatable {

    var countryCode: String
    var name: String
    @Relationship(inverse: \MoviesMovieEntity.productionCountries) var movie: MoviesMovieEntity?

    init(countryCode: String, name: String) {
        self.countryCode = countryCode
        self.name = name
    }

}
