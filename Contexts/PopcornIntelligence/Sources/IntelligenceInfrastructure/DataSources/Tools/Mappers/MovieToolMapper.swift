//
//  MovieToolMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

struct MovieToolMapper {

    func map(_ movie: Movie) -> MovieTool.Movie {
        MovieTool.Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            releaseDate: {
                guard let releaseDate = movie.releaseDate else {
                    return nil
                }

                return releaseDate.formatted()
            }()
        )
    }

}
