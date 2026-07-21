//
//  ExploreViewModel.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// A snapshot of all explore content loaded from various sources.
///
/// Contains collections of different media types displayed together in the explore
/// screen. Each collection is controlled by a feature flag.
public struct ExploreViewSnapshot: Equatable, Sendable {

    /// Movies from the discover endpoint.
    public let discoverMovies: [MoviePreview]
    /// Currently trending movies.
    public let trendingMovies: [MoviePreview]
    /// Popular movies.
    public let popularMovies: [MoviePreview]
    /// Currently trending TV series.
    public let trendingTVSeries: [TVSeriesPreview]
    /// Currently trending people.
    public let trendingPeople: [PersonPreview]

    public init(
        discoverMovies: [MoviePreview],
        trendingMovies: [MoviePreview],
        popularMovies: [MoviePreview],
        trendingTVSeries: [TVSeriesPreview],
        trendingPeople: [PersonPreview]
    ) {
        self.discoverMovies = discoverMovies
        self.trendingMovies = trendingMovies
        self.popularMovies = popularMovies
        self.trendingTVSeries = trendingTVSeries
        self.trendingPeople = trendingPeople
    }

}

/// Drives ``ExploreView``.
///
/// Loads every enabled content source once in parallel (`async let`). There is no
/// live stream: the content is fetched once when the view appears and re-fetched
/// only when ``reload()`` bumps ``reloadID`` (which reruns the view's `.task(id:)`).
@Observable
@MainActor
public final class ExploreViewModel {

    public typealias ViewSnapshot = ExploreViewSnapshot

    private static let logger = Logger.explore

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: ExploreDependencies
    private let navigator: any ExploreNavigating

    public init(
        dependencies: ExploreDependencies,
        navigator: any ExploreNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches every enabled content source in parallel.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``. A no-op once the content is already loaded.
    public func load() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info("User fetching explore content")

        let isDiscoverMoviesEnabled = (try? dependencies.isDiscoverMoviesEnabled()) ?? false
        let isTrendingMoviesEnabled = (try? dependencies.isTrendingMoviesEnabled()) ?? false
        let isPopularMoviesEnabled = (try? dependencies.isPopularMoviesEnabled()) ?? false
        let isTrendingTVSeriesEnabled = (try? dependencies.isTrendingTVSeriesEnabled()) ?? false
        let isTrendingPeopleEnabled = (try? dependencies.isTrendingPeopleEnabled()) ?? false

        let snapshot: ViewSnapshot
        do {
            async let discoverMovies =
                isDiscoverMoviesEnabled ? dependencies.fetchDiscoverMovies() : []
            async let trendingMovies =
                isTrendingMoviesEnabled ? dependencies.fetchTrendingMovies() : []
            async let popularMovies =
                isPopularMoviesEnabled ? dependencies.fetchPopularMovies() : []
            async let trendingTVSeries =
                isTrendingTVSeriesEnabled ? dependencies.fetchTrendingTVSeries() : []
            async let trendingPeople =
                isTrendingPeopleEnabled ? dependencies.fetchTrendingPeople() : []

            snapshot = try await ViewSnapshot(
                discoverMovies: discoverMovies,
                trendingMovies: trendingMovies,
                popularMovies: popularMovies,
                trendingTVSeries: trendingTVSeries,
                trendingPeople: trendingPeople
            )
        } catch {
            Self.logger.error(
                "Failed fetching explore content: \(error.localizedDescription, privacy: .public)"
            )
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

    public func selectTrendingMovies() {
        navigator.openTrendingMovies()
    }

    public func selectDiscoverMovies() {
        navigator.openDiscoverMovies()
    }

    public func selectMovie(id: Int, transitionID: String?) {
        navigator.openMovieDetails(id: id, transitionID: transitionID)
    }

    public func selectTVSeries(id: Int, transitionID: String?) {
        navigator.openTVSeriesDetails(id: id, transitionID: transitionID)
    }

    public func selectPerson(id: Int, transitionID: String?) {
        navigator.openPersonDetails(id: id, transitionID: transitionID)
    }

}

#if DEBUG
    public extension ExploreViewModel {

        /// A view model pinned to a fixed view state with mock dependencies and
        /// no-op navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> ExploreViewModel {
            ExploreViewModel(
                dependencies: .preview,
                navigator: NoOpExploreNavigator(),
                viewState: viewState
            )
        }

    }
#endif
