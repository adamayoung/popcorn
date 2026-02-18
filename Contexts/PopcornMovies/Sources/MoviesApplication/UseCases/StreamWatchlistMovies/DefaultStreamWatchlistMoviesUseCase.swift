//
//  DefaultStreamWatchlistMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
import OSLog

final class DefaultStreamWatchlistMoviesUseCase: StreamWatchlistMoviesUseCase {

    private static let logger = Logger.moviesApplication

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        Self.logger.debug("Starting stream for watchlist movies")

        let watchlistStream = await movieWatchlistRepository.moviesStream()
        return AsyncThrowingStream { continuation in
            let task = Task {
                var lastValue: [MoviePreviewDetails]?

                for try await watchlistMovies in watchlistStream {
                    guard !watchlistMovies.isEmpty else {
                        guard lastValue != [] else {
                            continue
                        }
                        lastValue = []
                        continuation.yield([])
                        continue
                    }

                    let appConfiguration: AppConfiguration
                    do {
                        appConfiguration = try await self.appConfigurationProvider
                            .appConfiguration()
                    } catch {
                        Self.logger.error("Failed to fetch app configuration: \(error)")
                        continue
                    }

                    let movieData = await self.fetchMovieData(for: watchlistMovies)

                    let mapper = MoviePreviewDetailsMapper()
                    let moviePreviews = movieData.map { moviePreview, imageCollection in
                        mapper.map(
                            moviePreview,
                            imageCollection: imageCollection,
                            imagesConfiguration: appConfiguration.images
                        )
                    }

                    guard lastValue != moviePreviews else {
                        continue
                    }

                    lastValue = moviePreviews
                    continuation.yield(moviePreviews)
                }

                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
                Self.logger.debug("Cancelled stream for watchlist movies")
            }
        }
    }

}

extension DefaultStreamWatchlistMoviesUseCase {

    private func fetchMovieData(
        for watchlistMovies: Set<WatchlistMovie>
    ) async -> [(MoviePreview, ImageCollection?)] {
        await withTaskGroup(returning: [(MoviePreview, ImageCollection?)].self) { taskGroup in
            for watchlistMovie in watchlistMovies {
                taskGroup.addTask {
                    do {
                        let movie = try await self.movieRepository
                            .movie(withID: watchlistMovie.id)
                        let imageCollection = try? await self.movieImageRepository
                            .imageCollection(forMovie: watchlistMovie.id)
                        let moviePreview = MoviePreview(
                            id: movie.id,
                            title: movie.title,
                            overview: movie.overview,
                            releaseDate: movie.releaseDate,
                            posterPath: movie.posterPath,
                            backdropPath: movie.backdropPath
                        )
                        return [(watchlistMovie.createdAt, moviePreview, imageCollection)]
                    } catch {
                        Self.logger.debug("Failed to fetch movie \(watchlistMovie.id): \(error)")
                        return []
                    }
                }
            }

            var results: [(Date, MoviePreview, ImageCollection?)] = []
            for await batch in taskGroup {
                results.append(contentsOf: batch)
            }

            return results
                .sorted { $0.0 > $1.0 }
                .map { ($0.1, $0.2) }
        }
    }

}
