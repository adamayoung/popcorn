//
//  WatchlistViewModel.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``WatchlistView`` once loaded.
public struct WatchlistViewSnapshot: Equatable, Sendable {

    public let movies: [MoviePreview]

    public init(movies: [MoviePreview]) {
        self.movies = movies
    }

}

/// Drives ``WatchlistView``. The MVVM replacement for `WatchlistFeature`.
///
/// Loading and live updates are driven by the view through ``load()`` from a
/// `.task(id:)`, so SwiftUI owns the lifetime: the work is cancelled on disappear
/// and restarted on reappear (or when ``reload()`` bumps ``reloadID``). There is
/// deliberately no view-model-owned `Task` — structured concurrency keeps the
/// stream tied to the view's lifetime with no manual cancellation.
///
/// The live ``WatchlistDependencies/streamWatchlistMovies`` subscription is the
/// single source of truth for post-fetch updates: when a movie is added to or
/// removed from the watchlist elsewhere, the stream re-emits the updated list.
@Observable
@MainActor
public final class WatchlistViewModel {

    public typealias ViewSnapshot = WatchlistViewSnapshot

    private static let logger = Logger.watchlist

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: WatchlistDependencies
    private let navigator: any WatchlistNavigating

    public init(
        dependencies: WatchlistDependencies,
        navigator: any WatchlistNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the watchlist movies, then observes live updates until cancelled.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
        await observeUpdates()
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

    // MARK: - Loading

    func fetch() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info("User fetching watchlist movies")

        let snapshot: ViewSnapshot
        do {
            let movies = try await dependencies.fetchWatchlistMovies()
            snapshot = ViewSnapshot(movies: movies)
        } catch {
            Self.logger.error(
                "Failed fetching watchlist movies: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
    }

    func observeUpdates() async {
        guard case .ready = viewState else {
            return
        }

        Self.logger.info("Starting watchlist movies stream")
        do {
            let stream = try await dependencies.streamWatchlistMovies()
            for try await movies in stream {
                applyMoviesUpdate(movies)
            }
        } catch is CancellationError {
            // Expected when the view disappears and the `.task` is cancelled.
        } catch {
            Self.logger.error(
                "Watchlist movies stream failed: \(error.localizedDescription, privacy: .public)"
            )
        }
    }

    private func applyMoviesUpdate(_ movies: [MoviePreview]) {
        guard case .ready = viewState else {
            return
        }
        viewState = .ready(ViewSnapshot(movies: movies))
    }

}

#if DEBUG
    public extension WatchlistViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> WatchlistViewModel {
            WatchlistViewModel(
                dependencies: .preview,
                navigator: NoOpWatchlistNavigator(),
                viewState: viewState
            )
        }

    }
#endif
