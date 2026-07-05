//
//  MoviePreviewMapper.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import DiscoverApplication
import Foundation
import MoviesApplication
import TrendingApplication

/// Maps a context `MoviePreviewDetails` (from Trending, Movies, or Discover) to the
/// feature's ``MoviePreview`` presentation model.
public struct MoviePreviewMapper {

    /// Creates a movie-preview mapper.
    public init() {}

    /// Maps a ``TrendingApplication`` `MoviePreviewDetails` to a presentation ``MoviePreview``.
    public func map(_ moviePreviewDetails: TrendingApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

    /// Maps a ``MoviesApplication`` `MoviePreviewDetails` to a presentation ``MoviePreview``.
    public func map(_ moviePreviewDetails: MoviesApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

    /// Maps a ``DiscoverApplication`` `MoviePreviewDetails` to a presentation ``MoviePreview``.
    public func map(_ moviePreviewDetails: DiscoverApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

}
