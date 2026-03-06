//
//  DefaultStreamMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
import OSLog

final class DefaultStreamMovieRecommendationsUseCase: StreamMovieRecommendationsUseCase {

    private static let logger = Logger.moviesApplication

    private let movieRecommendationRepository: any MovieRecommendationRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        movieRecommendationRepository: some MovieRecommendationRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.movieRecommendationRepository = movieRecommendationRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func stream(
        movieID: Movie.ID
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        await stream(movieID: movieID, limit: nil)
    }

    func stream(
        movieID: Movie.ID,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        Self.logger.debug(
            "Start streaming movie recommendations [forMovieID: \(movieID, privacy: .private)]"
        )
        let stream = await movieRecommendationRepository.recommendationsStream(forMovie: movieID, limit: limit)
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

                    let themeColors = await self.extractThemeColors(
                        for: moviePreviews,
                        imagesConfiguration: appConfiguration.images
                    )

                    let mapper = MoviePreviewDetailsMapper()
                    let moviePreviewDetails = moviePreviews.map {
                        mapper.map(
                            $0,
                            imageCollection: imageCollections[$0.id],
                            imagesConfiguration: appConfiguration.images,
                            themeColor: themeColors[$0.id]
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
                    "Movie recommendations stream terminated [forMovieID: \(movieID, privacy: .private)"
                )
                task.cancel()
            }
        }
    }

    func loadNextPage(movieID: Movie.ID) async throws(StreamMovieRecommendationsError) {
        do {
            try await movieRecommendationRepository.nextRecommendationsStreamPage(forMovie: movieID)
        } catch let error {
            throw StreamMovieRecommendationsError(error)
        }
    }

}

extension DefaultStreamMovieRecommendationsUseCase {

    private func imageCollections(
        for moviePreviews: [MoviePreview]
    ) async throws(StreamMovieRecommendationsError) -> [Int: ImageCollection] {
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
            throw StreamMovieRecommendationsError(error)
        }

        return imageCollections
    }

    private func extractThemeColors(
        for moviePreviews: [MoviePreview],
        imagesConfiguration: ImagesConfiguration
    ) async -> [Int: ThemeColor] {
        guard let themeColorProvider else {
            return [:]
        }

        var results: [Int: ThemeColor] = [:]

        for moviePreview in moviePreviews {
            guard let thumbnailURL = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)?.thumbnail
            else {
                continue
            }
            if let themeColor = await themeColorProvider.themeColor(for: thumbnailURL) {
                results[moviePreview.id] = themeColor
            }
        }

        return results
    }

}
