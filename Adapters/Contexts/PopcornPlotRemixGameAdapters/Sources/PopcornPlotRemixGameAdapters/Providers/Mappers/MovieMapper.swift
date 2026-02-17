//
//  MovieMapper.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import DiscoverApplication
import Foundation
import MoviesApplication
import PlotRemixGameDomain

struct MovieMapper {

    func map(_ movie: DiscoverApplication.MoviePreviewDetails) -> Movie {
        Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterURLSet?.path,
            backdropPath: movie.backdropURLSet?.path
        )
    }

    func map(_ movie: MoviesApplication.MoviePreviewDetails) -> Movie {
        Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterURLSet?.path,
            backdropPath: movie.backdropURLSet?.path
        )
    }

}
