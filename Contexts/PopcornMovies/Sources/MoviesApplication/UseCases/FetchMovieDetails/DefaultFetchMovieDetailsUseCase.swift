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
    private let favouriteMovieRepository: any FavouriteMovieRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieRepository: some MovieRepository,
        movieImageRepository: some MovieImageRepository,
        favouriteMovieRepository: some FavouriteMovieRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieImageRepository = movieImageRepository
        self.favouriteMovieRepository = favouriteMovieRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails {
        let movie: Movie
        let imageCollection: ImageCollection
        let isFavourite: Bool
        let appConfiguration: AppConfiguration
        do {
            (movie, imageCollection, isFavourite, appConfiguration) = try await (
                movieRepository.movie(withID: id),
                movieImageRepository.imageCollection(forMovie: id),
                favouriteMovieRepository.isFavourite(movieID: id),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieDetailsError(error)
        }

        let mapper = MovieDetailsMapper()
        return mapper.map(
            movie,
            imageCollection: imageCollection,
            isFavourite: isFavourite,
            imagesConfiguration: appConfiguration.images
        )
    }

}
