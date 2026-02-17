//
//  MoviesProductionCompanyEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class MoviesProductionCompanyEntity: Equatable {

    var companyID: Int
    var name: String
    var originCountry: String
    var logoPath: URL?
    @Relationship(inverse: \MoviesMovieEntity.productionCompanies) var movie: MoviesMovieEntity?

    init(companyID: Int, name: String, originCountry: String, logoPath: URL? = nil) {
        self.companyID = companyID
        self.name = name
        self.originCountry = originCountry
        self.logoPath = logoPath
    }

}
