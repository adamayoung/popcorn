//
//  MovieMapper.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import Foundation
import MoviesApplication
import PlotRemixGameDomain

///
/// A mapper that converts movie preview details to Plot Remix Game movie entities.
///
struct MovieMapper {

    ///
    /// Maps a Discover application movie preview to a Plot Remix Game movie.
    ///
    /// - Parameter movie: The Discover movie preview details to map.
    ///
    /// - Returns: A ``Movie`` entity for use in the Plot Remix Game domain.
    ///
    func map(_ movie: DiscoverApplication.MoviePreviewDetails) -> Movie {
        Movie(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterURLSet?.path,
            backdropPath: movie.backdropURLSet?.path
        )
    }

    ///
    /// Maps a Movies application movie preview to a Plot Remix Game movie.
    ///
    /// - Parameter movie: The Movies movie preview details to map.
    ///
    /// - Returns: A ``Movie`` entity for use in the Plot Remix Game domain.
    ///
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
