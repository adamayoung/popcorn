//
//  MovieProviderAdapter.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import DiscoverDomain
import Foundation
import MoviesApplication
import MoviesDomain
import PlotRemixGameDomain

///
/// An adapter that provides movies for the plot remix game domain.
///
/// Bridges the discover and movies application layers to the plot remix game
/// domain by wrapping movie discovery and recommendation use cases.
///
public struct MovieProviderAdapter: MovieProviding {

    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    private let fetchMovieRecommendationsUseCase: any FetchMovieRecommendationsUseCase

    ///
    /// Creates a movie provider adapter.
    ///
    /// - Parameters:
    ///   - fetchDiscoverMoviesUseCase: The use case for discovering movies.
    ///   - fetchMovieRecommendationsUseCase: The use case for fetching movie recommendations.
    ///
    public init(
        fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase,
        fetchMovieRecommendationsUseCase: some FetchMovieRecommendationsUseCase
    ) {
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
        self.fetchMovieRecommendationsUseCase = fetchMovieRecommendationsUseCase
    }

    ///
    /// Fetches random movies matching the specified filter.
    ///
    /// - Parameters:
    ///   - filter: The filter criteria for discovering movies.
    ///   - limit: The maximum number of movies to return.
    /// - Returns: An array of randomly selected movies.
    /// - Throws: ``MovieProviderError`` if the movies cannot be fetched.
    ///
    public func randomMovies(
        filter: PlotRemixGameDomain.MovieFilter,
        limit: Int
    ) async throws(MovieProviderError) -> [PlotRemixGameDomain.Movie] {
        let movieFilterMapper = DiscoverDomainMovieFilterMapper()

        let discoverMovieFilter = movieFilterMapper.map(filter)
        let moviePreviewDetails: [DiscoverApplication.MoviePreviewDetails]
        do {
            moviePreviewDetails = try await fetchDiscoverMoviesUseCase.execute(
                filter: discoverMovieFilter
            )
        } catch let error {
            throw MovieProviderError(error)
        }

        let mapper = MovieMapper()
        let movies = moviePreviewDetails
            .indices
            .shuffled()
            .prefix(limit)
            .map {
                let movie = moviePreviewDetails[$0]
                return mapper.map(movie)
            }

        return movies
    }

    ///
    /// Fetches random movies similar to the specified movie.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie to find similar movies for.
    ///   - limit: The maximum number of movies to return.
    /// - Returns: An array of randomly selected similar movies.
    /// - Throws: ``MovieProviderError`` if the movies cannot be fetched.
    ///
    public func randomSimilarMovies(
        to movieID: Int,
        limit: Int
    ) async throws(MovieProviderError) -> [PlotRemixGameDomain.Movie] {
        let moviePreviewDetails: [MoviesApplication.MoviePreviewDetails]
        do {
            moviePreviewDetails = try await fetchMovieRecommendationsUseCase.execute(movieID: movieID)
        } catch let error {
            throw MovieProviderError(error)
        }

        let mapper = MovieMapper()
        let movies = moviePreviewDetails
            .indices
            .shuffled()
            .prefix(limit)
            .map {
                let movie = moviePreviewDetails[$0]
                return mapper.map(movie)
            }

        return movies
    }

}

extension MovieProviderError {

    init(_ error: FetchDiscoverMoviesError) {
        switch error {
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    init(_ error: FetchMovieRecommendationsError) {
        switch error {
        case .notFound: self = .unknown()
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
