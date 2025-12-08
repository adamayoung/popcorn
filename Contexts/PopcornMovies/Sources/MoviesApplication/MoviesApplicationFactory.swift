//
//  MoviesApplicationFactory.swift
//  PopcornMovies
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import MoviesDomain

public final class MoviesApplicationFactory {

    private let movieRepository: any MovieRepository
    private let favouriteMovieRepository: any FavouriteMovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let popularMovieRepository: any PopularMovieRepository
    private let similarMovieRepository: any SimilarMovieRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieRepository: some MovieRepository,
        favouriteMovieRepository: some FavouriteMovieRepository,
        movieImageRepository: some MovieImageRepository,
        popularMovieRepository: some PopularMovieRepository,
        similarMovieRepository: some SimilarMovieRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.favouriteMovieRepository = favouriteMovieRepository
        self.movieImageRepository = movieImageRepository
        self.popularMovieRepository = popularMovieRepository
        self.similarMovieRepository = similarMovieRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            favouriteMovieRepository: favouriteMovieRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        DefaultStreamMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            favouriteMovieRepository: favouriteMovieRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeToggleFavouriteMovieUseCase() -> some ToggleFavouriteMovieUseCase {
        DefaultToggleFavouriteMovieUseCase(
            movieRepository: movieRepository,
            favouriteMovieRepository: favouriteMovieRepository
        )
    }

    public func makeFetchMovieImageCollectionUseCase() -> some FetchMovieImageCollectionUseCase {
        DefaultFetchMovieImageCollectionUseCase(
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchPopularMoviesUseCase() -> some FetchPopularMoviesUseCase {
        DefaultFetchPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        DefaultStreamPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        DefaultFetchSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        DefaultStreamSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
