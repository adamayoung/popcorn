//
//  DefaultFetchWatchlistMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchWatchlistMoviesUseCase: FetchWatchlistMoviesUseCase {

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

        let sortedWatchlistMovies = watchlistMovies.sorted { $0.createdAt > $1.createdAt }
        let movieData = await fetchMovieData(for: sortedWatchlistMovies)

        let mapper = MoviePreviewDetailsMapper()
        return movieData.map { moviePreview, imageCollection in
            mapper.map(
                moviePreview,
                imageCollection: imageCollection,
                imagesConfiguration: appConfiguration.images
            )
        }
    }

}

extension DefaultFetchWatchlistMoviesUseCase {

    private func fetchMovieData(
        for watchlistMovies: [WatchlistMovie]
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
