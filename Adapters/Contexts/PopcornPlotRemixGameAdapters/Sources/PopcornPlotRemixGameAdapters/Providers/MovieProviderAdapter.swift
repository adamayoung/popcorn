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

public struct MovieProviderAdapter: MovieProviding {

    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    private let fetchMovieRecommendationsUseCase: any FetchMovieRecommendationsUseCase

    public init(
        fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase,
        fetchMovieRecommendationsUseCase: some FetchMovieRecommendationsUseCase
    ) {
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
        self.fetchMovieRecommendationsUseCase = fetchMovieRecommendationsUseCase
    }

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
