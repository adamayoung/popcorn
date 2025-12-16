//
//  MovieMapper.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
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
