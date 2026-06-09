//
//  TrendingMoviesDependencies.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TrendingApplication

/// The dependencies required by ``TrendingMoviesViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TrendingMoviesClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct TrendingMoviesDependencies: Sendable {

    public var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]

    public init(
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview]
    ) {
        self.fetchTrendingMovies = fetchTrendingMovies
    }

}

public extension TrendingMoviesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TrendingMoviesClient.liveValue` exactly: same use case,
    /// same mapper.
    static func live(services: AppServices) -> TrendingMoviesDependencies {
        let fetchTrendingMovies = services.trendingFactory.makeFetchTrendingMoviesUseCase()

        return TrendingMoviesDependencies(
            fetchTrendingMovies: {
                let moviePreviews = try await fetchTrendingMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            }
        )
    }

}

#if DEBUG
    public extension TrendingMoviesDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TrendingMoviesClient.previewValue`).
        static var preview: TrendingMoviesDependencies {
            TrendingMoviesDependencies(
                fetchTrendingMovies: { MoviePreview.mocks }
            )
        }

    }
#endif
