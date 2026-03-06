//
//  DefaultStreamMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
import OSLog

final class DefaultStreamMovieDetailsUseCase: StreamMovieDetailsUseCase {

    private static let logger = Logger.moviesApplication

    private let movieRepository: any MovieRepository
    private let movieImageRepository: any MovieImageRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        movieRepository: some MovieRepository,
        movieImageRepository: some MovieImageRepository,
        movieWatchlistRepository: any MovieWatchlistRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.movieRepository = movieRepository
        self.movieImageRepository = movieImageRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error> {
        Self.logger.debug("Starting stream for MovieDetails [movieID: \(id, privacy: .private)]")

        let stream = await movieRepository.movieStream(withID: id)
        return AsyncThrowingStream { continuation in
            let task = Task {
                var lastValue: MovieDetails?

                for try await movie in stream {
                    guard let movie else {
                        continuation.yield(nil)
                        continue
                    }

                    let movieDetails = try await buildMovieDetails(for: movie, id: id)

                    guard lastValue != movieDetails else {
                        continue
                    }

                    lastValue = movieDetails
                    continuation.yield(movieDetails)
                }

                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
                Self.logger.debug(
                    "Cancelled stream for MovieDetails [movieID: \(id, privacy: .private)]"
                )
            }
        }
    }

    private func buildMovieDetails(
        for movie: Movie,
        id: Int
    ) async throws -> MovieDetails {
        let imageCollection: ImageCollection
        let certification: String?
        let isOnWatchlist: Bool
        let appConfiguration: AppConfiguration
        do {
            async let certificationTask = movieRepository.certification(forMovie: id)
            (imageCollection, isOnWatchlist, appConfiguration) = try await (
                movieImageRepository.imageCollection(forMovie: id),
                movieWatchlistRepository.isOnWatchlist(movieID: id),
                appConfigurationProvider.appConfiguration()
            )
            certification = try? await certificationTask
        } catch let error {
            throw FetchMovieDetailsError(error)
        }

        let themeColor = await extractThemeColor(
            posterPath: movie.posterPath,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MovieDetailsMapper()
        return mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: certification,
            isOnWatchlist: isOnWatchlist,
            imagesConfiguration: appConfiguration.images,
            themeColor: themeColor
        )
    }

}

extension DefaultStreamMovieDetailsUseCase {

    private func extractThemeColor(
        posterPath: URL?,
        imagesConfiguration: ImagesConfiguration
    ) async -> ThemeColor? {
        guard
            let themeColorProvider,
            let thumbnailURL = imagesConfiguration.posterURLSet(for: posterPath)?.thumbnail
        else {
            return nil
        }

        return await themeColorProvider.themeColor(for: thumbnailURL)
    }

}
