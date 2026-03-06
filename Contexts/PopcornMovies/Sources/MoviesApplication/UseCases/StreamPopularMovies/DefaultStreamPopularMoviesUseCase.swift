//
//  DefaultStreamPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultStreamPopularMoviesUseCase: StreamPopularMoviesUseCase {

    private let popularMovieRepository: any PopularMovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        popularMovieRepository: some PopularMovieRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.popularMovieRepository = popularMovieRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        let stream = await popularMovieRepository.popularStream()

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

            continuation.onTermination = { _ in task.cancel() }
        }
    }

    func loadNextPage() async throws(StreamPopularMoviesError) {
        do {
            try await popularMovieRepository.nextPopularStreamPage()
        } catch let error {
            throw StreamPopularMoviesError(error)
        }
    }

    func refresh() async throws(StreamPopularMoviesError) {}

}

extension DefaultStreamPopularMoviesUseCase {

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
