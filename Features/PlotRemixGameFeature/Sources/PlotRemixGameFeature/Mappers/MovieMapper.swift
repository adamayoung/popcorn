//
//  MovieMapper.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

struct MovieMapper {

    func map(_ movie: PlotRemixGameDomain.Movie) -> Movie {
        Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath
        )
    }

}
