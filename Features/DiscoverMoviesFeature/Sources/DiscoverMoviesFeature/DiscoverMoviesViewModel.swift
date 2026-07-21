//
//  DiscoverMoviesViewModel.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``DiscoverMoviesView`` once loaded.
public struct DiscoverMoviesViewSnapshot: Equatable, Sendable {

    /// The discover movies to display.
    public let movies: [MoviePreview]

    /// Creates a discover movies snapshot.
    ///
    /// - Parameter movies: The discover movies to display.
    public init(movies: [MoviePreview]) {
        self.movies = movies
    }

}

/// Drives ``DiscoverMoviesView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). Pagination is driven the same way —
/// each grid cell's `.task` calls ``loadMoreIfNeeded(at:)`` as it appears. There is
/// deliberately no view-model-owned `Task`: structured concurrency keeps the work
/// tied to the view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class DiscoverMoviesViewModel {

    public typealias ViewSnapshot = DiscoverMoviesViewSnapshot

    private static let logger = Logger.discoverMovies

    /// Load the next page once a cell within this many items of the end appears —
    /// roughly two rows ahead on the widest grid, so the next page is ready before
    /// the user reaches the bottom.
    private static let loadMoreThreshold = 12

    /// The most pages a single ``loadMore()`` will fetch while skipping pages that
    /// contain only already-seen movies. The discover feed can shift between
    /// requests, so a page can be entirely duplicates; this bounds the catch-up so
    /// a run of duplicate pages can't loop unchecked.
    private static let maxLoadMoreAttempts = 3

    /// The current view state driving ``DiscoverMoviesView``.
    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    /// Whether at least one more page of discover movies is available to load.
    public private(set) var hasMore = false

    /// Whether a "load more" fetch is in flight, so the view can show a footer
    /// indicator without disturbing the loaded grid.
    public private(set) var isLoadingMore = false

    private var currentPage = 1

    private let dependencies: DiscoverMoviesDependencies
    private let navigator: any DiscoverMoviesNavigating

    /// Creates a discover movies view model.
    ///
    /// - Parameters:
    ///   - dependencies: The data dependencies used to fetch discover movies.
    ///   - navigator: The navigator handling movie-details navigation.
    ///   - viewState: The initial view state. Defaults to `.initial`.
    public init(
        dependencies: DiscoverMoviesDependencies,
        navigator: any DiscoverMoviesNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Loading

    /// Fetches the first page of discover movies.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``. A successful fetch resets
    /// pagination to the fresh first page.
    public func load() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        hasMore = false
        Self.logger.info("User fetching discover movies")

        let page: MoviePreviewPage
        do {
            page = try await dependencies.fetchDiscoverMovies(1)
        } catch {
            // A tab-switch cancellation is not a real failure — `applyLoadFailure`
            // resets it to `.initial` so the next `.task(id:)` run re-fetches.
            if !Task.isCancelled, !(error is CancellationError) {
                Self.logger.error("Failed fetching discover movies: \(error, privacy: .public)")
            }
            viewState.applyLoadFailure(error)
            return
        }

        currentPage = page.page
        hasMore = page.hasMore
        viewState = .ready(ViewSnapshot(movies: page.movies))
    }

    /// Requests the next page if the cell at `index` is within
    /// ``loadMoreThreshold`` of the end of the loaded list.
    ///
    /// Drive this from each grid cell's `.task`, passing the cell's position in the
    /// loaded movies. Cells nearer the top return without fetching.
    ///
    /// - Parameter index: The cell's position in the loaded movies.
    public func loadMoreIfNeeded(at index: Int) async {
        guard let movies = viewState.content?.movies else {
            return
        }
        guard index >= movies.count - Self.loadMoreThreshold else {
            return
        }

        await loadMore()
    }

    /// Fetches and appends the next page of discover movies.
    ///
    /// A no-op unless the grid is `.ready`, more pages remain, and no other
    /// load-more is already in flight — the `isLoadingMore` guard is set before the
    /// first `await`, so re-entrant calls from sibling cells bail. New movies are
    /// de-duplicated by id (the discover feed can shift between page requests, so
    /// pages can overlap). A failure keeps the loaded grid intact and leaves
    /// pagination unchanged, so a later cell appearance retries.
    public func loadMore() async {
        guard case .ready(let snapshot) = viewState, hasMore, !isLoadingMore else {
            return
        }

        isLoadingMore = true
        defer { isLoadingMore = false }

        var movies = snapshot.movies
        do {
            for _ in 0 ..< Self.maxLoadMoreAttempts {
                guard hasMore else {
                    break
                }

                Self.logger.info("User fetching discover movies page \(self.currentPage + 1)")
                let page = try await dependencies.fetchDiscoverMovies(currentPage + 1)
                currentPage = page.page
                hasMore = page.hasMore

                var seenIDs = Set(movies.map(\.id))
                let newMovies = page.movies.filter { seenIDs.insert($0.id).inserted }
                guard newMovies.isEmpty else {
                    movies += newMovies
                    viewState = .ready(ViewSnapshot(movies: movies))
                    return
                }
                // The page held only movies already shown; try the next one so the
                // grid keeps growing and near-end cells re-trigger.
            }
        } catch {
            // Non-fatal: keep the grid and leave pagination untouched so the next
            // near-end cell appearance retries. Cancellation (the triggering cell
            // scrolled away) is not a real failure.
            if !Task.isCancelled, !(error is CancellationError) {
                Self.logger.error("Failed fetching more discover movies: \(error, privacy: .public)")
            }
        }
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    /// Requests movie details for the selected movie.
    ///
    /// - Parameters:
    ///   - id: The identifier of the selected movie.
    ///   - transitionID: The zoom-transition source identifier of the tapped poster.
    public func selectMovie(id: Int, transitionID: String?) {
        navigator.openMovieDetails(id: id, transitionID: transitionID)
    }

}

#if DEBUG
    public extension DiscoverMoviesViewModel {

        /// A view model with no-op dependencies and navigation, for previews and
        /// snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot> = .initial
        ) -> DiscoverMoviesViewModel {
            DiscoverMoviesViewModel(
                dependencies: .preview,
                navigator: NoOpDiscoverMoviesNavigator(),
                viewState: viewState
            )
        }

        /// A ready view model showing `movies`, for previews and snapshot tests.
        static func preview(movies: [MoviePreview]) -> DiscoverMoviesViewModel {
            preview(viewState: .ready(ViewSnapshot(movies: movies)))
        }

    }
#endif
