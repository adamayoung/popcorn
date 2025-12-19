//
//  DefaultStreamSimilarMoviesUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 02/12/2025.
//

import CoreDomain
import Foundation
import MoviesDomain
import OSLog

final class DefaultStreamSimilarMoviesUseCase: StreamSimilarMoviesUseCase {

    private static let logger = Logger.moviesApplication

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

    func stream(
        movieID: Movie.ID,
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        await stream(movieID: movieID, limit: nil)
    }

    func stream(
        movieID: Movie.ID,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        Self.logger.debug(
            "Start streaming similar movies [toMovieID: \(movieID, privacy: .private)")
        let stream = await similarMovieRepository.similarStream(toMovie: movieID, limit: limit)
        return AsyncThrowingStream { continuation in
            let task = Task {
                var lastValue: [MoviePreviewDetails]?

                for try await moviePreviews in stream {
                    guard let moviePreviews else {
                        continuation.yield([])
                        continue
                    }

                    let (appConfiguration, imageCollections) = try await (
                        appConfigurationProvider.appConfiguration(),
                        imageCollections(for: moviePreviews)
                    )

                    let mapper = MoviePreviewDetailsMapper()
                    let moviePreviewDetails = moviePreviews.map {
                        mapper.map(
                            $0,
                            imageCollection: imageCollections[$0.id],
                            imagesConfiguration: appConfiguration.images
                        )
                    }

                    guard lastValue != moviePreviewDetails else {
                        continue
                    }

                    lastValue = moviePreviewDetails
                    continuation.yield(moviePreviewDetails)
                }

                continuation.finish()
            }

            continuation.onTermination = { _ in
                Self.logger.debug(
                    "Similar movies stream terminated [toMovieID: \(movieID, privacy: .private)")
                task.cancel()
            }
        }
    }

    func loadNextPage(movieID: Movie.ID) async throws(StreamSimilarMoviesError) {
        do {
            try await similarMovieRepository.nextSimilarStreamPage(forMovie: movieID)
        } catch let error {
            throw StreamSimilarMoviesError(error)
        }
    }

}

extension DefaultStreamSimilarMoviesUseCase {

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
