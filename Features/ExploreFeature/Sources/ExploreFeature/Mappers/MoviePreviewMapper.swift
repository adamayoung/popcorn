//
//  MoviePreviewMapper.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import Foundation
import MoviesApplication
import TrendingApplication

struct MoviePreviewMapper {

    func map(_ moviePreviewDetails: TrendingApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

    func map(_ moviePreviewDetails: MoviesApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

    func map(_ moviePreviewDetails: DiscoverApplication.MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

}
