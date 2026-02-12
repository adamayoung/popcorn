//
//  DefaultFetchPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchPopularMoviesUseCase: FetchPopularMoviesUseCase {

    private let popularMovieRepository: any PopularMovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        popularMovieRepository: some PopularMovieRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.popularMovieRepository = popularMovieRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute() async throws(FetchPopularMoviesError) -> [MoviePreviewDetails] {
        try await execute(page: 1)
    }

    func execute(page: Int) async throws(FetchPopularMoviesError) -> [MoviePreviewDetails] {
        let moviePreviews: [MoviePreview]
        let appConfiguration: AppConfiguration
        do {
            (moviePreviews, appConfiguration) = try await (
                popularMovieRepository.popular(page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchPopularMoviesError(error)
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

extension DefaultFetchPopularMoviesUseCase {

    private func imageCollections(
        for moviePreviews: [MoviePreview]
    ) async throws(FetchPopularMoviesError) -> [Int: ImageCollection] {
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
            throw FetchPopularMoviesError(error)
        }

        return imageCollections
    }

}
