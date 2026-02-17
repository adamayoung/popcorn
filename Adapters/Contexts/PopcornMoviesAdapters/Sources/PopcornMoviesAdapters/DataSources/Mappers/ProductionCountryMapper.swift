//
//  ProductionCountryMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct ProductionCountryMapper {

    func map(_ dto: TMDb.ProductionCountry) -> MoviesDomain.ProductionCountry {
        MoviesDomain.ProductionCountry(
            countryCode: dto.countryCode,
            name: dto.name
        )
    }

}
