//
//  MovieDetailsClientFactory.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 28/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication
import MoviesKitAdapters

struct MovieDetailsClientFactory {

    @Dependency(\.streamMovieDetails) private var streamMovieDetails: StreamMovieDetailsUseCase
    @Dependency(\.streamSimilarMovies) private var streamSimilarMovies: StreamSimilarMoviesUseCase
    @Dependency(\.toggleFavouriteMovie) private var toggleFavouriteMovie:
        ToggleFavouriteMovieUseCase

    func makeStreamMovieDetails() -> StreamMovieDetailsUseCase {
        self.streamMovieDetails
    }

    func makeStreamSimilarMovies() -> StreamSimilarMoviesUseCase {
        self.streamSimilarMovies
    }

    func makeToggleFavouriteMovie() -> ToggleFavouriteMovieUseCase {
        self.toggleFavouriteMovie
    }

}
