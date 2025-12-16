//
//  DefaultFetchMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/06/2025.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    private let movieRepository: any MovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let appConfigurationProvider: any AppConfigurationProviding

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

    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails {
        let movie: Movie
        let imageCollection: ImageCollection
        let isOnWatchlist: Bool
        let appConfiguration: AppConfiguration
        do {
            (movie, imageCollection, isOnWatchlist, appConfiguration) = try await (
                movieRepository.movie(withID: id),
                movieImageRepository.imageCollection(forMovie: id),
                movieWatchlistRepository.isOnWatchlist(movieID: id),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieDetailsError(error)
        }

        let mapper = MovieDetailsMapper()
        return mapper.map(
            movie,
            imageCollection: imageCollection,
            isOnWatchlist: isOnWatchlist,
            imagesConfiguration: appConfiguration.images
        )
    }

}
