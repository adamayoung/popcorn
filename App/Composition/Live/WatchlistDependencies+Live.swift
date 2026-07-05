//
//  WatchlistDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import MoviesApplication
import MoviesComposition
import WatchlistFeature

extension WatchlistDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Wires the fetch and stream watchlist use cases with their mapper and
    /// translates domain errors to ``FetchWatchlistError``.
    static func live(services: AppServices) -> WatchlistDependencies {
        let fetchWatchlistMovies = services.moviesFactory.makeFetchWatchlistMoviesUseCase()
        let streamWatchlistMovies = services.moviesFactory.makeStreamWatchlistMoviesUseCase()

        return WatchlistDependencies(
            fetchWatchlistMovies: {
                do {
                    let moviePreviews = try await fetchWatchlistMovies.execute()
                    let mapper = MoviePreviewMapper()
                    return moviePreviews.map(mapper.map)
                } catch let error as FetchWatchlistMoviesError {
                    throw FetchWatchlistError(error)
                }
            },
            streamWatchlistMovies: {
                let moviesStream = await streamWatchlistMovies.stream()
                return AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    let task = Task {
                        let mapper = MoviePreviewMapper()
                        do {
                            for try await moviePreviews in moviesStream {
                                continuation.yield(moviePreviews.map(mapper.map))
                            }
                            continuation.finish()
                        } catch {
                            continuation.finish(throwing: error)
                        }
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            }
        )
    }

}
