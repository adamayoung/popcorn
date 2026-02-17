//
//  ProductionCompanyMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct ProductionCompanyMapper {

    func map(_ dto: TMDb.ProductionCompany) -> MoviesDomain.ProductionCompany {
        MoviesDomain.ProductionCompany(
            id: dto.id,
            name: dto.name,
            originCountry: dto.originCountry,
            logoPath: dto.logoPath
        )
    }

}
