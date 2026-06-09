//
//  TrendingMoviesViewModel.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog

/// Drives ``TrendingMoviesScreen``. The MVVM replacement for `TrendingMoviesFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// Mirrors the former `TrendingMoviesFeature` reducer exactly: there is no error
/// path — a failed fetch is logged and leaves ``movies`` unchanged.
@Observable
@MainActor
public final class TrendingMoviesViewModel {

    private static let logger = Logger.trendingMovies

    public private(set) var movies: [MoviePreview] = []
    public private(set) var isLoading: Bool

    public var isInitiallyLoading: Bool {
        movies.isEmpty && isLoading
    }

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry.
    public private(set) var reloadID = 0

    private let dependencies: TrendingMoviesDependencies
    private let navigator: any TrendingMoviesNavigating

    public init(
        dependencies: TrendingMoviesDependencies,
        navigator: any TrendingMoviesNavigating,
        movies: [MoviePreview] = [],
        isLoading: Bool = false
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.movies = movies
        self.isLoading = isLoading
    }

    // MARK: - Loading

    /// Fetches trending movies.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        isLoading = true
        Self.logger.info("User fetching trending movies")

        let movies: [MoviePreview]
        do {
            movies = try await dependencies.fetchTrendingMovies()
        } catch {
            Self.logger.error("Failed fetching trending movies: \(error, privacy: .public)")
            return
        }

        self.movies = movies
        isLoading = false
    }

    /// Retries loading by changing ``reloadID``, which reruns the view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectMovie(id: Int) {
        navigator.openMovieDetails(id: id)
    }

}

#if DEBUG
    public extension TrendingMoviesViewModel {

        /// A view model with no-op dependencies and navigation, for previews and
        /// snapshot tests.
        static func preview(
            movies: [MoviePreview] = [],
            isLoading: Bool = false
        ) -> TrendingMoviesViewModel {
            TrendingMoviesViewModel(
                dependencies: .preview,
                navigator: NoOpTrendingMoviesNavigator(),
                movies: movies,
                isLoading: isLoading
            )
        }

    }
#endif
