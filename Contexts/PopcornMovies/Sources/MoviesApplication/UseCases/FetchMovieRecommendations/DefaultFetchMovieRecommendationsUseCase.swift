//
//  DefaultFetchMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieRecommendationsUseCase: FetchMovieRecommendationsUseCase {

    private let movieRecommendationRepository: any MovieRecommendationRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieRecommendationRepository: some MovieRecommendationRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRecommendationRepository = movieRecommendationRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        try await execute(movieID: movieID, page: 1)
    }

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        let moviePreviews: [MoviePreview]
        let appConfiguration: AppConfiguration
        do {
            (moviePreviews, appConfiguration) = try await (
                movieRecommendationRepository.recommendations(forMovie: movieID, page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieRecommendationsError(error)
        }

        let imageCollections = try await imageCollections(for: moviePreviews)

        let mapper = MoviePreviewDetailsMapper()
        return moviePreviews.map {
            mapper.map(
                $0,
                imageCollection: imageCollections[$0.id],
                imagesConfiguration: appConfiguration.images
            )
        }
    }

}

extension DefaultFetchMovieRecommendationsUseCase {

    private func imageCollections(
        for moviePreviews: [MoviePreview]
    ) async throws(FetchMovieRecommendationsError) -> [Int: ImageCollection] {
        let imageCollections: [Int: ImageCollection]
        do {
            imageCollections = try await withThrowingTaskGroup { taskGroup in
                for moviePreview in moviePreviews {
                    taskGroup.addTask {
                        try await (
                            moviePreview.id,
                            self.movieImageRepository.imageCollection(forMovie: moviePreview.id)
                        )
                    }
                }

                var results: [Int: ImageCollection] = [:]
                for try await (id, imageCollection) in taskGroup {
                    results[id] = imageCollection
                }

                return results
            }
        } catch let error {
            throw FetchMovieRecommendationsError(error)
        }

        return imageCollections
    }

}
