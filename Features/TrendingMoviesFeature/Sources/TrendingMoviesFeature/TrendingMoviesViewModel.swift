//
//  TrendingMoviesViewModel.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``TrendingMoviesView`` once loaded.
public struct TrendingMoviesViewSnapshot: Equatable, Sendable {

    public let movies: [MoviePreview]

    public init(movies: [MoviePreview]) {
        self.movies = movies
    }

}

/// Drives ``TrendingMoviesView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class TrendingMoviesViewModel {

    public typealias ViewSnapshot = TrendingMoviesViewSnapshot

    private static let logger = Logger.trendingMovies

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: TrendingMoviesDependencies
    private let navigator: any TrendingMoviesNavigating

    public init(
        dependencies: TrendingMoviesDependencies,
        navigator: any TrendingMoviesNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Loading

    /// Fetches trending movies.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info("User fetching trending movies")

        let snapshot: ViewSnapshot
        do {
            let movies = try await dependencies.fetchTrendingMovies()
            snapshot = ViewSnapshot(movies: movies)
        } catch {
            // A tab-switch cancellation is not a real failure — `applyLoadFailure`
            // resets it to `.initial` so the next `.task(id:)` run re-fetches.
            if !Task.isCancelled, !(error is CancellationError) {
                Self.logger.error("Failed fetching trending movies: \(error, privacy: .public)")
            }
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectMovie(id: Int, transitionID: String?) {
        navigator.openMovieDetails(id: id, transitionID: transitionID)
    }

}

#if DEBUG
    public extension TrendingMoviesViewModel {

        /// A view model with no-op dependencies and navigation, for previews and
        /// snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot> = .initial
        ) -> TrendingMoviesViewModel {
            TrendingMoviesViewModel(
                dependencies: .preview,
                navigator: NoOpTrendingMoviesNavigator(),
                viewState: viewState
            )
        }

        /// A ready view model showing `movies`, for previews and snapshot tests.
        static func preview(movies: [MoviePreview]) -> TrendingMoviesViewModel {
            preview(viewState: .ready(ViewSnapshot(movies: movies)))
        }

    }
#endif
