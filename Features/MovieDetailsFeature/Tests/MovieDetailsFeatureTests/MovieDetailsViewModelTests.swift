//
//  MovieDetailsViewModelTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieDetailsFeature
import Presentation
import Synchronization
import Testing

@Suite("MovieDetailsViewModel Tests")
struct MovieDetailsViewModelTests {

    @Test("fetch success loads movie, recommendations, and credits")
    @MainActor
    func fetchSuccessLoadsAllData() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                fetchRecommendedMovies: { _ in Self.testRecommendations },
                fetchCredits: { _ in Self.testCredits }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchMovie: { _ in throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("stream update replaces the loaded movie (loaded before updated)")
    @MainActor
    func streamUpdateReplacesMovie() async {
        let updatedMovie = Movie(id: 123, title: "Test Movie", overview: "Test overview", isOnWatchlist: true)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in Self.testMovie },
                streamMovie: { _ in
                    AsyncThrowingStream { continuation in
                        continuation.yield(updatedMovie)
                        continuation.finish()
                    }
                },
                fetchRecommendedMovies: { _ in Self.testRecommendations },
                fetchCredits: { _ in Self.testCredits }
            )
        )

        await viewModel.fetch()
        await viewModel.observeMovieUpdates()

        #expect(viewModel.viewState == .ready(MovieDetailsViewSnapshot(
            movie: updatedMovie,
            recommendedMovies: Self.testRecommendations,
            castMembers: Self.testCredits.castMembers,
            crewMembers: Self.testCredits.crewMembers
        )))
    }

    @Test("toggleOnWatchlist calls the dependency but does not mutate state")
    @MainActor
    func toggleDoesNotMutateState() async {
        let toggled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                toggleOnWatchlist: { _ in toggled.withLock { $0 = true } }
            ),
            viewState: .ready(snapshot),
            isWatchlistEnabled: true
        )

        await viewModel.toggleOnWatchlist()

        #expect(toggled.withLock { $0 } == true)
        #expect(viewModel.viewState == .ready(snapshot))
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in fetchCalled.withLock { $0 = true }; return Self.testMovie }
            ),
            viewState: .ready(snapshot)
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(snapshot))
    }

    @Test("fetch is a no-op when already loading")
    @MainActor
    func fetchNoOpWhenLoading() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchMovie: { _ in fetchCalled.withLock { $0 = true }; return Self.testMovie }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("updateFeatureFlags reflects the dependency flags")
    @MainActor
    func updateFeatureFlagsReflectsDependencies() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                isWatchlistEnabled: { true },
                isIntelligenceEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isWatchlistEnabled)
        #expect(viewModel.isIntelligenceEnabled)
        #expect(viewModel.isBackdropFocalPointEnabled)
    }

    @Test("navigation methods invoke the navigator with the correct identifiers")
    @MainActor
    func navigationInvokesNavigator() {
        let navigator = SpyMovieDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456)
        viewModel.selectPerson(id: 789)
        viewModel.openCastAndCrew()
        viewModel.openIntelligence()

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedPersonID == 789)
        #expect(navigator.openedCastAndCrewMovieID == 123)
        #expect(navigator.openedIntelligenceID == 123)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyMovieDetailsNavigator: MovieDetailsNavigating {
    var openedMovieID: Int?
    var openedIntelligenceID: Int?
    var openedPersonID: Int?
    var openedCastAndCrewMovieID: Int?

    func openMovieDetails(id: Int) {
        openedMovieID = id
    }

    func openMovieIntelligence(id: Int) {
        openedIntelligenceID = id
    }

    func openPersonDetails(id: Int) {
        openedPersonID = id
    }

    func openMovieCastAndCrew(movieID: Int) {
        openedCastAndCrewMovieID = movieID
    }
}

// MARK: - Factories

extension MovieDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: MovieDetailsDependencies = stubDependencies(),
        navigator: any MovieDetailsNavigating = SpyMovieDetailsNavigator(),
        viewState: ViewState<MovieDetailsViewSnapshot> = .initial,
        isWatchlistEnabled: Bool = false
    ) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            movieID: 123,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            isWatchlistEnabled: isWatchlistEnabled
        )
    }

    static func stubDependencies(
        fetchMovie: @escaping @Sendable (Int) async throws -> Movie = { _ in testMovie },
        streamMovie: @escaping @Sendable (Int) async throws -> AsyncThrowingStream<Movie?, Error> = { _ in
            AsyncThrowingStream { $0.finish() }
        },
        fetchRecommendedMovies: @escaping @Sendable (Int) async throws -> [MoviePreview] = { _ in [] },
        fetchCredits: @escaping @Sendable (Int) async throws -> Credits = { _ in
            Credits(id: 123, castMembers: [], crewMembers: [])
        },
        toggleOnWatchlist: @escaping @Sendable (Int) async throws -> Void = { _ in },
        isWatchlistEnabled: @escaping @Sendable () throws -> Bool = { true },
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool = { true },
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool = { true },
        isRecommendedMoviesEnabled: @escaping @Sendable () throws -> Bool = { true },
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> MovieDetailsDependencies {
        MovieDetailsDependencies(
            fetchMovie: fetchMovie,
            streamMovie: streamMovie,
            fetchRecommendedMovies: fetchRecommendedMovies,
            fetchCredits: fetchCredits,
            toggleOnWatchlist: toggleOnWatchlist,
            isWatchlistEnabled: isWatchlistEnabled,
            isIntelligenceEnabled: isIntelligenceEnabled,
            isCastAndCrewEnabled: isCastAndCrewEnabled,
            isRecommendedMoviesEnabled: isRecommendedMoviesEnabled,
            isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
        )
    }

}

// MARK: - Test Data

extension MovieDetailsViewModelTests {

    static let testMovie = Movie(
        id: 123,
        title: "Test Movie",
        tagline: "A test tagline",
        overview: "Test overview",
        runtime: 120,
        genres: [Genre(id: 28, name: "Action"), Genre(id: 53, name: "Thriller")],
        budget: 50_000_000,
        revenue: 150_000_000,
        homepageURL: URL(string: "https://example.com/movie"),
        isOnWatchlist: false
    )

    static let testRecommendations = [
        MoviePreview(id: 1, title: "Rec 1"),
        MoviePreview(id: 2, title: "Rec 2")
    ]

    static let testCredits = Credits(
        id: 123,
        castMembers: [
            CastMember(id: "cast-1", personID: 456, characterName: "Character", personName: "Actor")
        ],
        crewMembers: [
            CrewMember(id: "crew-1", personID: 789, personName: "Director", job: "Director", department: "Directing")
        ]
    )

    static var testViewSnapshot: MovieDetailsViewSnapshot {
        MovieDetailsViewSnapshot(
            movie: testMovie,
            recommendedMovies: testRecommendations,
            castMembers: testCredits.castMembers,
            crewMembers: testCredits.crewMembers
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
