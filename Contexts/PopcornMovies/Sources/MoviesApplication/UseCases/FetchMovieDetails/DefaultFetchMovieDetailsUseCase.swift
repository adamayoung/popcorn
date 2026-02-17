//
//  DefaultFetchMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

///
/// Default implementation of ``FetchMovieDetailsUseCase`` that aggregates movie data from multiple repositories.
///
/// This use case implementation coordinates data fetching from four sources:
/// - Movie repository for core movie information
/// - Image repository for visual assets
/// - Watchlist repository for user-specific state
/// - App configuration provider for image URL construction
///
/// All data fetching operations are performed concurrently to minimize latency.
/// The aggregated results are then mapped into a ``MovieDetails`` object suitable
/// for presentation in the UI.
///
final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    /// Repository providing access to movie data.
    private let movieRepository: any MovieRepository

    /// Repository providing access to movie images.
    private let movieImageRepository: any MovieImageRepository

    /// Repository managing movie watchlist state.
    private let movieWatchlistRepository: any MovieWatchlistRepository

    /// Provider supplying application configuration including image base URLs.
    private let appConfigurationProvider: any AppConfigurationProviding

    ///
    /// Creates a new fetch movie details use case.
    ///
    /// - Parameters:
    ///   - movieRepository: Repository for fetching movie data
    ///   - movieImageRepository: Repository for fetching movie images
    ///   - movieWatchlistRepository: Repository for checking watchlist status
    ///   - appConfigurationProvider: Provider for application configuration
    ///
    init(
        movieRepository: some MovieRepository,
        movieImageRepository: some MovieImageRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieImageRepository = movieImageRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    ///
    /// Fetches comprehensive details for a movie by its identifier.
    ///
    /// This method performs four concurrent operations to fetch all required data:
    /// 1. Fetches core movie information (title, overview, runtime, etc.)
    /// 2. Fetches associated images (posters, backdrops, logos)
    /// 3. Checks if the movie is on the user's watchlist
    /// 4. Retrieves app configuration for image URL construction
    ///
    /// The aggregated data is then mapped into a ``MovieDetails`` object using
    /// ``MovieDetailsMapper``. All errors from underlying repositories are converted
    /// to ``FetchMovieDetailsError`` for consistent error handling.
    ///
    /// - Parameter id: The unique identifier of the movie to fetch details for
    ///
    /// - Returns: A ``MovieDetails`` object containing comprehensive movie information
    ///
    /// - Throws: ``FetchMovieDetailsError`` if any data fetching operation fails
    ///
    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails {
        let movie: Movie
        let imageCollection: ImageCollection
        let certification: String?
        let isOnWatchlist: Bool
        let appConfiguration: AppConfiguration
        do {
            async let certificationTask = movieRepository.certification(forMovie: id)
            (movie, imageCollection, isOnWatchlist, appConfiguration) = try await (
                movieRepository.movie(withID: id),
                movieImageRepository.imageCollection(forMovie: id),
                movieWatchlistRepository.isOnWatchlist(movieID: id),
                appConfigurationProvider.appConfiguration()
            )
            certification = try? await certificationTask
        } catch let error {
            throw FetchMovieDetailsError(error)
        }

        let mapper = MovieDetailsMapper()
        return mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: certification,
            isOnWatchlist: isOnWatchlist,
            imagesConfiguration: appConfiguration.images
        )
    }

}
