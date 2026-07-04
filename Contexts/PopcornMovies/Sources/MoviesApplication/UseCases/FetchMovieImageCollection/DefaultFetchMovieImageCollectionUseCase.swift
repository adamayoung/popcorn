//
//  DefaultFetchMovieImageCollectionUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
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
            async let imageCollectionTask = movieImageRepository.imageCollection(forMovie: movieID)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (imageCollection, appConfiguration) = try await (imageCollectionTask, appConfigurationTask)
        } catch let error {
            throw FetchMovieImageCollectionError(error)
        }

        let mapper = ImageCollectionDetailsMapper()
        return mapper.map(
            imageCollection, imagesConfiguration: appConfiguration.images
        )
    }

}
