//
//  DiscoverMoviesViewModelTestSupport.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import DiscoverMoviesFeature
import Foundation
import Presentation

// MARK: - Spy Navigator

@MainActor
final class SpyDiscoverMoviesNavigator: DiscoverMoviesNavigating {
    var openedMovieID: Int?
    var openedMovieTransitionID: String?

    func openMovieDetails(id: Int, transitionID: String?) {
        openedMovieID = id
        openedMovieTransitionID = transitionID
    }
}

// MARK: - Loading Observers

/// Captures the view model's loading state at the moment the fetch closure runs,
/// so a test can assert loading was set before the network call resolves.
@MainActor
final class LoadingObserver {
    weak var viewModel: DiscoverMoviesViewModel?
    var loadingDuringFetch = false

    func capture() {
        loadingDuringFetch = viewModel?.viewState.isLoading ?? false
    }
}

/// Captures `isLoadingMore` while a load-more fetch is in flight, and optionally
/// runs an action (e.g. a re-entrant `loadMore`) at that same moment.
@MainActor
final class LoadMoreObserver {
    weak var viewModel: DiscoverMoviesViewModel?
    var loadingMoreDuringFetch = false
    var onFetch: (@MainActor () async -> Void)?

    func capture() async {
        loadingMoreDuringFetch = viewModel?.isLoadingMore ?? false
        if let onFetch {
            await onFetch()
        }
    }
}

// MARK: - Factories & Data

enum DiscoverMoviesTestSupport {

    @MainActor
    static func makeViewModel(
        dependencies: DiscoverMoviesDependencies = stubDependencies(),
        navigator: any DiscoverMoviesNavigating = SpyDiscoverMoviesNavigator(),
        viewState: ViewState<DiscoverMoviesViewSnapshot> = .initial
    ) -> DiscoverMoviesViewModel {
        DiscoverMoviesViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchDiscoverMovies: @escaping @Sendable (Int) async throws -> MoviePreviewPage = { page in
            MoviePreviewPage(page: page, totalPages: 1, movies: [])
        }
    ) -> DiscoverMoviesDependencies {
        DiscoverMoviesDependencies(fetchDiscoverMovies: fetchDiscoverMovies)
    }

    /// A single-page result (no further pages) wrapping `movies`.
    static func singlePage(_ movies: [MoviePreview]) -> MoviePreviewPage {
        MoviePreviewPage(page: 1, totalPages: 1, movies: movies)
    }

    static let testMovies = [
        MoviePreview(id: 1, title: "Movie 1"),
        MoviePreview(id: 2, title: "Movie 2")
    ]

}

// MARK: - Test Error

enum DiscoverMoviesTestError: Error, Equatable {
    case generic
}
