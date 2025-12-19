//
//  DefaultStreamMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 02/12/2025.
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

    init(
        movieRepository: some MovieRepository,
        movieImageRepository: some MovieImageRepository,
        movieWatchlistRepository: any MovieWatchlistRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieImageRepository = movieImageRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error> {
        Self.logger.debug("Starting stream for MovieDetails(id: \(id))")

        let stream = await movieRepository.movieStream(withID: id)
        return AsyncThrowingStream { continuation in
            let task = Task {
                var lastValue: MovieDetails?

                for try await movie in stream {
                    guard let movie else {
                        continuation.yield(nil)
                        continue
                    }

                    let imageCollection: ImageCollection
                    let isOnWatchlist: Bool
                    let appConfiguration: AppConfiguration
                    do {
                        (imageCollection, isOnWatchlist, appConfiguration) = try await (
                            movieImageRepository.imageCollection(forMovie: id),
                            movieWatchlistRepository.isOnWatchlist(movieID: id),
                            appConfigurationProvider.appConfiguration()
                        )
                    } catch let error {
                        throw FetchMovieDetailsError(error)
                    }

                    let mapper = MovieDetailsMapper()
                    let movieDetails = mapper.map(
                        movie,
                        imageCollection: imageCollection,
                        isOnWatchlist: isOnWatchlist,
                        imagesConfiguration: appConfiguration.images
                    )

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
                Self.logger.debug("Cancelled stream for MovieDetails(id: \(id))")
            }
        }
    }

}
