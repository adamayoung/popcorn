//
//  WatchlistClient.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import MoviesApplication

@DependencyClient
struct WatchlistClient: Sendable {

    var fetchWatchlistMovies: @Sendable () async throws -> [MoviePreview]
    var streamWatchlistMovies: @Sendable () async throws -> AsyncThrowingStream<[MoviePreview], Error>

}

extension WatchlistClient: DependencyKey {

    static var liveValue: WatchlistClient {
        @Dependency(\.fetchWatchlistMovies) var fetchWatchlistMovies
        @Dependency(\.streamWatchlistMovies) var streamWatchlistMovies

        return WatchlistClient(
            fetchWatchlistMovies: {
                let moviePreviews = try await fetchWatchlistMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
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

    static var previewValue: WatchlistClient {
        WatchlistClient(
            fetchWatchlistMovies: {
                MoviePreview.mocks
            },
            streamWatchlistMovies: {
                AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    continuation.yield(MoviePreview.mocks)
                    continuation.finish()
                }
            }
        )
    }

}

extension DependencyValues {

    var watchlistClient: WatchlistClient {
        get {
            self[WatchlistClient.self]
        }
        set {
            self[WatchlistClient.self] = newValue
        }
    }

}
