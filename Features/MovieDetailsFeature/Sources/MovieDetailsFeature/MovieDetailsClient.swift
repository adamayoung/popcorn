//
//  MovieDetailsClient.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication
import OSLog
import PopcornMoviesAdapters

@DependencyClient
struct MovieDetailsClient: Sendable {

    private static let logger = Logger(
        subsystem: "MovieDetailsFeature",
        category: "MovieDetailsClient"
    )

    var streamMovie: @Sendable (Int) async throws -> AsyncThrowingStream<Movie?, Error>
    var streamSimilar: @Sendable (Int) async throws -> AsyncThrowingStream<[MoviePreview], Error>
    var toggleFavourite: @Sendable (Int) async throws -> Void

}

extension MovieDetailsClient: DependencyKey {

    static var liveValue: MovieDetailsClient {
        @Dependency(\.streamMovieDetails) var streamMovieDetails
        @Dependency(\.streamSimilarMovies) var streamSimilarMovies
        @Dependency(\.toggleFavouriteMovie) var toggleFavouriteMovie

        return MovieDetailsClient(
            streamMovie: { id in
                let movieStream = await streamMovieDetails.stream(id: id)
                return AsyncThrowingStream<Movie?, Error> { continuation in
                    let task = Task {
                        let mapper = MovieMapper()
                        for try await movie in movieStream {
                            guard let movie else {
                                continuation.yield(nil)
                                continue
                            }

                            continuation.yield(mapper.map(movie))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            streamSimilar: { id in
                let moviePreviewStream = await streamSimilarMovies.stream(movieID: id, limit: 5)
                return AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    let task = Task {
                        let mapper = MoviePreviewMapper()
                        for try await moviePreviews in moviePreviewStream {
                            Self.logger.trace("Streaming \(moviePreviews.count) similar movies")
                            continuation.yield(moviePreviews.map(mapper.map))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            toggleFavourite: { id in
                try await toggleFavouriteMovie.execute(id: id)
            }
        )
    }

    static var previewValue: MovieDetailsClient {
        MovieDetailsClient(
            streamMovie: { _ in
                AsyncThrowingStream<Movie?, Error> { continuation in
                    continuation.yield(Movie.mock)
                    continuation.finish()
                }
            },
            streamSimilar: { _ in
                AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    continuation.yield(MoviePreview.mocks)
                    continuation.finish()
                }
            },
            toggleFavourite: { _ in }
        )
    }

}

extension DependencyValues {

    var movieDetailsClient: MovieDetailsClient {
        get { self[MovieDetailsClient.self] }
        set { self[MovieDetailsClient.self] = newValue }
    }

}
