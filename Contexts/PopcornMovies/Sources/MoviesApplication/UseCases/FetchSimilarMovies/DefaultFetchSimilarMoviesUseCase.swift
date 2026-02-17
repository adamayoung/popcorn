//
//  DefaultFetchSimilarMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchSimilarMoviesUseCase: FetchSimilarMoviesUseCase {

    private let similarMovieRepository: any SimilarMovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        similarMovieRepository: some SimilarMovieRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.similarMovieRepository = similarMovieRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails] {
        try await execute(movieID: movieID, page: 1)
    }

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails] {
        let moviePreviews: [MoviePreview]
        let appConfiguration: AppConfiguration
        do {
            (moviePreviews, appConfiguration) = try await (
                similarMovieRepository.similar(toMovie: movieID, page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchSimilarMoviesError(error)
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

extension DefaultFetchSimilarMoviesUseCase {

    private func imageCollections(
        for moviePreviews: [MoviePreview]
    ) async throws(FetchSimilarMoviesError) -> [Int: ImageCollection] {
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
            throw FetchSimilarMoviesError(error)
        }

        return imageCollections
    }

}
