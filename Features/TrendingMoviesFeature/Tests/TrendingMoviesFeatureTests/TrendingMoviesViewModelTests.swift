//
//  TrendingMoviesViewModelTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Synchronization
import Testing
@testable import TrendingMoviesFeature

@Suite("TrendingMoviesViewModel Tests")
struct TrendingMoviesViewModelTests {

    @Test("load populates movies from the dependency")
    @MainActor
    func loadPopulatesMovies() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { Self.testMovies }
            )
        )

        await viewModel.load()

        #expect(viewModel.movies == Self.testMovies)
    }

    @Test("load clears isLoading on success")
    @MainActor
    func loadClearsLoadingOnSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { Self.testMovies }
            )
        )

        await viewModel.load()

        #expect(viewModel.isLoading == false)
    }

    @Test("load sets isLoading true while fetching, then clears it")
    @MainActor
    func loadSetsLoadingWhileFetching() async {
        let observer = LoadingObserver()
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    await observer.capture()
                    return Self.testMovies
                }
            )
        )
        observer.viewModel = viewModel

        #expect(viewModel.isLoading == false)
        await viewModel.load()

        #expect(observer.loadingDuringFetch == true)
        #expect(viewModel.isLoading == false)
    }

    @Test("load leaves movies unchanged on failure")
    @MainActor
    func loadLeavesMoviesUnchangedOnFailure() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    fetchCalled.withLock { $0 = true }
                    throw TestError.generic
                }
            )
        )

        await viewModel.load()

        #expect(fetchCalled.withLock { $0 } == true)
        #expect(viewModel.movies.isEmpty)
    }

    @Test("isInitiallyLoading is true while loading with no movies")
    @MainActor
    func isInitiallyLoadingWhenEmptyAndLoading() {
        let viewModel = Self.makeViewModel(isLoading: true)

        #expect(viewModel.isInitiallyLoading)
    }

    @Test("isInitiallyLoading is false once movies are present")
    @MainActor
    func isInitiallyLoadingFalseWithMovies() {
        let viewModel = Self.makeViewModel(movies: Self.testMovies, isLoading: true)

        #expect(viewModel.isInitiallyLoading == false)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()

        let initialID = viewModel.reloadID
        viewModel.reload()

        #expect(viewModel.reloadID == initialID + 1)
    }

    @Test("selectMovie forwards the id and transitionID to the navigator")
    @MainActor
    func selectMovieInvokesNavigator() {
        let navigator = SpyTrendingMoviesNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: "456_trending-movies-grid")

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == "456_trending-movies-grid")
    }

    @Test("selectMovie forwards a nil transitionID when there is no zoom source")
    @MainActor
    func selectMovieForwardsNilTransitionID() {
        let navigator = SpyTrendingMoviesNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: nil)

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == nil)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTrendingMoviesNavigator: TrendingMoviesNavigating {
    var openedMovieID: Int?
    var openedMovieTransitionID: String?

    func openMovieDetails(id: Int, transitionID: String?) {
        openedMovieID = id
        openedMovieTransitionID = transitionID
    }
}

// MARK: - Loading Observer

/// Captures the view model's `isLoading` value at the moment the fetch closure
/// runs, so a test can assert loading was set before the network call resolves.
@MainActor
private final class LoadingObserver {
    weak var viewModel: TrendingMoviesViewModel?
    var loadingDuringFetch = false

    func capture() {
        loadingDuringFetch = viewModel?.isLoading ?? false
    }
}

// MARK: - Factories

extension TrendingMoviesViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TrendingMoviesDependencies = stubDependencies(),
        navigator: any TrendingMoviesNavigating = SpyTrendingMoviesNavigator(),
        movies: [MoviePreview] = [],
        isLoading: Bool = false
    ) -> TrendingMoviesViewModel {
        TrendingMoviesViewModel(
            dependencies: dependencies,
            navigator: navigator,
            movies: movies,
            isLoading: isLoading
        )
    }

    static func stubDependencies(
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview] = { [] }
    ) -> TrendingMoviesDependencies {
        TrendingMoviesDependencies(
            fetchTrendingMovies: fetchTrendingMovies
        )
    }

}

// MARK: - Test Data

extension TrendingMoviesViewModelTests {

    static let testMovies = [
        MoviePreview(id: 1, title: "Movie 1"),
        MoviePreview(id: 2, title: "Movie 2")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
