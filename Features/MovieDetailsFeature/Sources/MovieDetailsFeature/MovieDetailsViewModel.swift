//
//  MovieDetailsViewModel.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// Drives ``MovieDetailsView``.
///
/// The screen renders progressively: ``viewState`` gates the primary movie content and
/// becomes `.ready` as soon as the movie itself loads, while the recommended-movies and
/// cast-and-crew carousels each load independently into their own view state. A failure
/// in either section degrades that section only — it never fails the whole screen.
///
/// Loading and live updates are driven by the view through ``load()`` from a
/// `.task(id:)`, so SwiftUI owns the lifetime: the work is cancelled on disappear
/// and restarted on reappear (or when ``reload()`` bumps ``reloadID``). There is
/// deliberately no view-model-owned `Task` — structured concurrency keeps the
/// streams tied to the view's lifetime with no manual cancellation.
///
/// The live ``MovieDetailsDependencies/streamMovie`` subscription is the single
/// source of truth for post-fetch movie mutations (including watchlist on/off):
/// ``toggleOnWatchlist()`` persists the change and the stream re-emits the updated
/// movie — it does not mutate ``viewState`` directly.
@Observable
@MainActor
public final class MovieDetailsViewModel {

    private static let logger = Logger.movieDetails

    /// The primary movie content. Becomes `.ready` once the movie has loaded, without
    /// waiting for the recommended-movies or cast-and-crew sections.
    public private(set) var viewState: ViewState<Movie>

    /// The recommended-movies carousel, loaded independently after the movie is ready.
    public private(set) var recommendedMoviesState: ViewState<[MoviePreview]>

    /// The cast-and-crew carousel, loaded independently after the movie is ready.
    public private(set) var castAndCrewState: ViewState<Credits>

    public private(set) var isWatchlistEnabled: Bool
    public private(set) var isIntelligenceEnabled: Bool
    public private(set) var isBackdropFocalPointEnabled: Bool

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let movieID: Int
    public let transitionID: String?

    private let dependencies: MovieDetailsDependencies
    private let navigator: any MovieDetailsNavigating

    public init(
        movieID: Int,
        transitionID: String? = nil,
        dependencies: MovieDetailsDependencies,
        navigator: any MovieDetailsNavigating,
        viewState: ViewState<Movie> = .initial,
        recommendedMoviesState: ViewState<[MoviePreview]> = .initial,
        castAndCrewState: ViewState<Credits> = .initial,
        isWatchlistEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) {
        self.movieID = movieID
        self.transitionID = transitionID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.recommendedMoviesState = recommendedMoviesState
        self.castAndCrewState = castAndCrewState
        self.isWatchlistEnabled = isWatchlistEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

    // MARK: - Lifecycle

    public func didAppear() {
        updateFeatureFlags()
    }

    public func updateFeatureFlags() {
        isWatchlistEnabled = (try? dependencies.isWatchlistEnabled()) ?? false
        isIntelligenceEnabled = (try? dependencies.isIntelligenceEnabled()) ?? false
        isBackdropFocalPointEnabled = (try? dependencies.isBackdropFocalPointEnabled()) ?? false
    }

    /// Fetches the movie, then loads the sections and observes live movie updates.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``. The sections and the live stream run
    /// concurrently once the movie is ready, so cancellation propagates to all of them.
    public func load() async {
        await fetch()
        guard viewState.isReady else {
            return
        }

        async let recommended: Void = loadRecommendedMovies()
        async let castAndCrew: Void = loadCastAndCrew()
        async let updates: Void = observeMovieUpdates()
        _ = await (recommended, castAndCrew, updates)
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    public func toggleOnWatchlist() async {
        guard isWatchlistEnabled else {
            return
        }

        Self.logger.info("User toggling movie on watchlist [movieID: \(self.movieID, privacy: .private)]")
        do {
            try await dependencies.toggleOnWatchlist(movieID)
        } catch {
            Self.logger.error(
                "Failed toggling movie on watchlist [movieID: \(self.movieID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
        }
        // Intentionally no state mutation: the live movie stream re-emits the updated movie.
    }

    // MARK: - Navigation

    public func selectMovie(id: Int) {
        navigator.openMovieDetails(id: id)
    }

    public func selectPerson(id: Int) {
        navigator.openPersonDetails(id: id)
    }

    public func openCastAndCrew() {
        navigator.openMovieCastAndCrew(movieID: movieID)
    }

    public func openIntelligence() {
        navigator.openMovieIntelligence(id: movieID)
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
        Self.logger.info("User fetching movie details")

        do {
            let movie = try await dependencies.fetchMovie(movieID)
            viewState = .ready(movie)
        } catch {
            Self.logger.error(
                "Failed fetching movie details: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
        }
    }

    func loadRecommendedMovies() async {
        guard (try? dependencies.isRecommendedMoviesEnabled()) == true else {
            recommendedMoviesState = .initial
            return
        }
        guard !recommendedMoviesState.isReady, !recommendedMoviesState.isLoading else {
            return
        }

        recommendedMoviesState = .loading
        do {
            let movies = try await dependencies.fetchRecommendedMovies(movieID)
            recommendedMoviesState = .ready(movies)
        } catch {
            Self.logger.error(
                "Failed fetching recommended movies: \(error.localizedDescription, privacy: .public)"
            )
            recommendedMoviesState.applyLoadFailure(error)
        }
    }

    func loadCastAndCrew() async {
        guard (try? dependencies.isCastAndCrewEnabled()) == true else {
            castAndCrewState = .initial
            return
        }
        guard !castAndCrewState.isReady, !castAndCrewState.isLoading else {
            return
        }

        castAndCrewState = .loading
        do {
            let credits = try await dependencies.fetchCredits(movieID)
            castAndCrewState = .ready(credits)
        } catch {
            Self.logger.error(
                "Failed fetching cast and crew: \(error.localizedDescription, privacy: .public)"
            )
            castAndCrewState.applyLoadFailure(error)
        }
    }

    func observeMovieUpdates() async {
        guard case .ready = viewState else {
            return
        }

        Self.logger.info("Starting movie details stream")
        do {
            let stream = try await dependencies.streamMovie(movieID)
            for try await movie in stream {
                guard let movie else { continue }
                applyMovieUpdate(movie)
            }
        } catch is CancellationError {
            // Expected when the view disappears and the `.task` is cancelled.
        } catch {
            Self.logger.error(
                "Movie details stream failed: \(error.localizedDescription, privacy: .public)"
            )
        }
    }

    private func applyMovieUpdate(_ movie: Movie) {
        guard case .ready = viewState else {
            return
        }
        viewState = .ready(movie)
    }

}

#if DEBUG
    public extension MovieDetailsViewModel {

        /// A view model pinned to fixed view states with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<Movie>,
            recommendedMoviesState: ViewState<[MoviePreview]> = .initial,
            castAndCrewState: ViewState<Credits> = .initial,
            isWatchlistEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) -> MovieDetailsViewModel {
            MovieDetailsViewModel(
                movieID: viewState.content?.id ?? 0,
                dependencies: .preview,
                navigator: NoOpMovieDetailsNavigator(),
                viewState: viewState,
                recommendedMoviesState: recommendedMoviesState,
                castAndCrewState: castAndCrewState,
                isWatchlistEnabled: isWatchlistEnabled,
                isIntelligenceEnabled: isIntelligenceEnabled,
                isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
            )
        }

    }
#endif
