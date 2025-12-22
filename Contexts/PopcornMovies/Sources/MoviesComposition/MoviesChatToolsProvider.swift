//
//  MoviesChatToolsProvider.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation
import MoviesDomain
import MoviesInfrastructure

/// Provider for movie chat tools
public struct MoviesChatToolsProvider: MovieChatToolsProviding {

    private let movieRepository: any MovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let similarMovieRepository: any SimilarMovieRepository

    /// Creates a new movie chat tools provider
    /// - Parameters:
    ///   - movieRepository: Repository for fetching movie details
    ///   - movieImageRepository: Repository for fetching movie images
    ///   - similarMovieRepository: Repository for fetching similar movies
    public init(
        movieRepository: any MovieRepository,
        movieImageRepository: any MovieImageRepository,
        similarMovieRepository: any SimilarMovieRepository
    ) {
        self.movieRepository = movieRepository
        self.movieImageRepository = movieImageRepository
        self.similarMovieRepository = similarMovieRepository
    }

    public func tools(for movieID: Int) -> [any Sendable] {
        [
            MovieDetailsTool(movieID: movieID, movieRepository: movieRepository),
            MovieImagesTool(movieID: movieID, movieImageRepository: movieImageRepository),
            MovieRecommendationsTool(movieID: movieID, similarMovieRepository: similarMovieRepository)
        ]
    }

}
