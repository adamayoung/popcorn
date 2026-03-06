//
//  DefaultFetchWatchlistMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
import OSLog

final class DefaultFetchWatchlistMoviesUseCase: FetchWatchlistMoviesUseCase {

    private static let logger = Logger.moviesApplication

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute() async throws(FetchWatchlistMoviesError) -> [MoviePreviewDetails] {
        let watchlistMovies: Set<WatchlistMovie>
        let appConfiguration: AppConfiguration
        do {
            (watchlistMovies, appConfiguration) = try await (
                movieWatchlistRepository.movies(),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchWatchlistMoviesError(error)
        }

        guard !watchlistMovies.isEmpty else {
            return []
        }

        let movieData = await fetchMovieData(for: watchlistMovies)
        let themeColors = await extractThemeColors(
            for: movieData.map(\.0),
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MoviePreviewDetailsMapper()
        return movieData.map { moviePreview, imageCollection in
            mapper.map(
                moviePreview,
                imageCollection: imageCollection,
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[moviePreview.id]
            )
        }
    }

}

extension DefaultFetchWatchlistMoviesUseCase {

    private func fetchMovieData(
        for watchlistMovies: Set<WatchlistMovie>
    ) async -> [(MoviePreview, ImageCollection?)] {
        await withTaskGroup(returning: [(MoviePreview, ImageCollection?)].self) { taskGroup in
            for watchlistMovie in watchlistMovies {
                taskGroup.addTask {
                    do {
                        let movie = try await self.movieRepository.movie(withID: watchlistMovie.id)
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
