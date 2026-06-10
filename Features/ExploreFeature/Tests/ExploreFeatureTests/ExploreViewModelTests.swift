//
//  ExploreViewModelTests.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import ExploreFeature
import Foundation
import Presentation
import Synchronization
import Testing

@Suite("ExploreViewModel Tests")
struct ExploreViewModelTests {

    // MARK: - Loading

    @Test("load success populates all five carousels")
    @MainActor
    func loadSuccessPopulatesAllCarousels() async {
        let viewModel = Self.makeViewModel(dependencies: Self.stubDependencies())

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.fullSnapshot))
    }

    @Test("load failure sets viewState to error")
    @MainActor
    func loadFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { throw TestError.generic }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("load is a no-op when already loading (guards re-entrancy)")
    @MainActor
    func loadNoOpWhenLoading() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchDiscoverMovies: {
                    fetchCalled.withLock { $0 = true }
                    return Self.movies
                }
            ),
            viewState: .loading
        )

        await viewModel.load()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .loading)
    }

    @Test("cancelled load resets to initial (no spurious error) so the next .task re-fetches")
    @MainActor
    func loadCancellationResetsToInitial() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { throw CancellationError() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .initial)
        #expect(viewModel.viewState.isError == false)
    }

    @Test("load is a no-op when already ready")
    @MainActor
    func loadNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.fullSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchDiscoverMovies: { fetchCalled.withLock { $0 = true }; return Self.movies }
            ),
            viewState: .ready(snapshot)
        )

        await viewModel.load()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(snapshot))
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()
        let before = viewModel.reloadID

        viewModel.reload()

        #expect(viewModel.reloadID == before + 1)
    }

    // MARK: - Feature-flag gating

    @Test("a disabled source yields an empty array and is not fetched")
    @MainActor
    func disabledSourceYieldsEmpty() async {
        let discoverFetched = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchDiscoverMovies: { discoverFetched.withLock { $0 = true }; return Self.movies },
                isDiscoverMoviesEnabled: { false }
            )
        )

        await viewModel.load()

        #expect(discoverFetched.withLock { $0 } == false)
        guard case .ready(let snapshot) = viewModel.viewState else {
            Issue.record("Expected ready state")
            return
        }
        #expect(snapshot.discoverMovies.isEmpty)
        #expect(snapshot.trendingMovies == Self.movies)
    }

    @Test("all sources disabled yields an empty ready snapshot")
    @MainActor
    func allSourcesDisabledYieldsEmptySnapshot() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                isDiscoverMoviesEnabled: { false },
                isTrendingMoviesEnabled: { false },
                isPopularMoviesEnabled: { false },
                isTrendingTVSeriesEnabled: { false },
                isTrendingPeopleEnabled: { false }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.emptySnapshot))
    }

    // MARK: - Navigation

    @Test("selectMovie forwards the id and transitionID to the navigator")
    @MainActor
    func selectMovieForwardsTransitionID() {
        let navigator = SpyExploreNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 12, transitionID: "movie-12")

        #expect(navigator.openedMovieID == 12)
        #expect(navigator.openedMovieTransitionID == "movie-12")
    }

    @Test("selectTVSeries forwards the id and transitionID to the navigator")
    @MainActor
    func selectTVSeriesForwardsTransitionID() {
        let navigator = SpyExploreNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectTVSeries(id: 34, transitionID: "tv-34")

        #expect(navigator.openedTVSeriesID == 34)
        #expect(navigator.openedTVSeriesTransitionID == "tv-34")
    }

    @Test("selectPerson forwards the id and transitionID to the navigator")
    @MainActor
    func selectPersonForwardsTransitionID() {
        let navigator = SpyExploreNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectPerson(id: 56, transitionID: "person-56")

        #expect(navigator.openedPersonID == 56)
        #expect(navigator.openedPersonTransitionID == "person-56")
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyExploreNavigator: ExploreNavigating {
    var openedMovieID: Int?
    var openedMovieTransitionID: String?
    var openedTVSeriesID: Int?
    var openedTVSeriesTransitionID: String?
    var openedPersonID: Int?
    var openedPersonTransitionID: String?

    func openMovieDetails(id: Int, transitionID: String?) {
        openedMovieID = id
        openedMovieTransitionID = transitionID
    }

    func openTVSeriesDetails(id: Int, transitionID: String?) {
        openedTVSeriesID = id
        openedTVSeriesTransitionID = transitionID
    }

    func openPersonDetails(id: Int, transitionID: String?) {
        openedPersonID = id
        openedPersonTransitionID = transitionID
    }
}

// MARK: - Factories

extension ExploreViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: ExploreDependencies = stubDependencies(),
        navigator: any ExploreNavigating = SpyExploreNavigator(),
        viewState: ViewState<ExploreViewSnapshot> = .initial
    ) -> ExploreViewModel {
        ExploreViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchDiscoverMovies: @escaping @Sendable () async throws -> [MoviePreview] = { movies },
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview] = { movies },
        fetchPopularMovies: @escaping @Sendable () async throws -> [MoviePreview] = { movies },
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview] = { tvSeries },
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview] = { people },
        isDiscoverMoviesEnabled: @escaping @Sendable () throws -> Bool = { true },
        isTrendingMoviesEnabled: @escaping @Sendable () throws -> Bool = { true },
        isPopularMoviesEnabled: @escaping @Sendable () throws -> Bool = { true },
        isTrendingTVSeriesEnabled: @escaping @Sendable () throws -> Bool = { true },
        isTrendingPeopleEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> ExploreDependencies {
        ExploreDependencies(
            fetchDiscoverMovies: fetchDiscoverMovies,
            fetchTrendingMovies: fetchTrendingMovies,
            fetchPopularMovies: fetchPopularMovies,
            fetchTrendingTVSeries: fetchTrendingTVSeries,
            fetchTrendingPeople: fetchTrendingPeople,
            isDiscoverMoviesEnabled: isDiscoverMoviesEnabled,
            isTrendingMoviesEnabled: isTrendingMoviesEnabled,
            isPopularMoviesEnabled: isPopularMoviesEnabled,
            isTrendingTVSeriesEnabled: isTrendingTVSeriesEnabled,
            isTrendingPeopleEnabled: isTrendingPeopleEnabled
        )
    }

}

// MARK: - Test Data

extension ExploreViewModelTests {

    static let movies = [
        MoviePreview(id: 1, title: "Movie 1"),
        MoviePreview(id: 2, title: "Movie 2")
    ]

    static let tvSeries = [
        TVSeriesPreview(id: 10, name: "Series 1"),
        TVSeriesPreview(id: 11, name: "Series 2")
    ]

    static let people = [
        PersonPreview(id: 20, name: "Person 1"),
        PersonPreview(id: 21, name: "Person 2")
    ]

    static var fullSnapshot: ExploreViewSnapshot {
        ExploreViewSnapshot(
            discoverMovies: movies,
            trendingMovies: movies,
            popularMovies: movies,
            trendingTVSeries: tvSeries,
            trendingPeople: people
        )
    }

    static var emptySnapshot: ExploreViewSnapshot {
        ExploreViewSnapshot(
            discoverMovies: [],
            trendingMovies: [],
            popularMovies: [],
            trendingTVSeries: [],
            trendingPeople: []
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
