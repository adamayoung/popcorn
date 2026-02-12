//
//  DefaultFetchMovieImageCollectionUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieImageCollectionUseCase: FetchMovieImageCollectionUseCase {

    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchMovieImageCollectionError)
    -> ImageCollectionDetails {
        let imageCollection: ImageCollection
        let appConfiguration: AppConfiguration
        do {
            (imageCollection, appConfiguration) = try await (
                movieImageRepository.imageCollection(forMovie: movieID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieImageCollectionError(error)
        }

        let mapper = ImageCollectionDetailsMapper()
        return mapper.map(
            imageCollection, imagesConfiguration: appConfiguration.images
        )
    }

}
