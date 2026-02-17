//
//  MovieStatusMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct MovieStatusMapper {

    func map(_ dto: TMDb.Status) -> MoviesDomain.MovieStatus {
        switch dto {
        case .rumoured:
            .rumoured

        case .planned:
            .planned

        case .inProduction:
            .inProduction

        case .postProduction:
            .postProduction

        case .released:
            .released

        case .cancelled:
            .cancelled
        }
    }

}
