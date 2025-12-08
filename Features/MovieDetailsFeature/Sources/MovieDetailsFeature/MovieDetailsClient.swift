//
//  MovieDetailsClient.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication
import MoviesKitAdapters

struct MovieDetailsClient: Sendable {

    var streamMovie: @Sendable (Int) async -> AsyncThrowingStream<Movie?, Error>
    var streamSimilar: @Sendable (Int) async -> AsyncThrowingStream<[MoviePreview], Error>
    var toggleFavourite: @Sendable (Int) async throws -> Void

}

extension MovieDetailsClient: DependencyKey {

    static var liveValue: MovieDetailsClient {
        let factory = MovieDetailsClientFactory()
        return MovieDetailsClient(
            streamMovie: { id in
                let useCase = factory.makeStreamMovieDetails()
                let movieStream = await useCase.stream(id: id)
                return AsyncThrowingStream<Movie?, Error> { continuation in
                    let task = Task {
                        let mapper = MovieMapper()
                        for try await movie in movieStream {
                            guard let movie else {
                                continuation.yield(nil)
                                continue
                            }

                            print("Streaming movie '\(movie.title)'")
                            continuation.yield(mapper.map(movie))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            streamSimilar: { id in
                let useCase = factory.makeStreamSimilarMovies()
                let moviePreviewStream = await useCase.stream(movieID: id, limit: 5)
                return AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    let task = Task {
                        let mapper = MoviePreviewMapper()
                        for try await moviePreviews in moviePreviewStream {

                            print("Streaming \(moviePreviews.count) similar movies")
                            continuation.yield(moviePreviews.map(mapper.map))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            toggleFavourite: { id in
                let useCase = factory.makeToggleFavouriteMovie()
                try await useCase.execute(id: id)
            }
        )
    }

    static var previewValue: MovieDetailsClient {
        MovieDetailsClient(
            streamMovie: { _ in
                AsyncThrowingStream<Movie?, Error> { continuation in
                    continuation.yield(Movie.mock)
                }
            },
            streamSimilar: { _ in
                AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    continuation.yield(MoviePreview.mocks)
                }
            },
            toggleFavourite: { _ in
            }
        )
    }

}

extension DependencyValues {

    var movieDetails: MovieDetailsClient {
        get {
            self[MovieDetailsClient.self]
        }
        set {
            self[MovieDetailsClient.self] = newValue
        }
    }

}
