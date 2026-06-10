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

/// The data shown by ``MovieDetailsView`` once loaded.
public struct MovieDetailsViewSnapshot: Equatable, Sendable {

    public let movie: Movie
    public let recommendedMovies: [MoviePreview]
    public let castMembers: [CastMember]
    public let crewMembers: [CrewMember]

    public init(
        movie: Movie,
        recommendedMovies: [MoviePreview],
        castMembers: [CastMember],
        crewMembers: [CrewMember]
    ) {
        self.movie = movie
        self.recommendedMovies = recommendedMovies
        self.castMembers = castMembers
        self.crewMembers = crewMembers
    }

}

/// Drives ``MovieDetailsView``. The MVVM replacement for `MovieDetailsFeature`.
///
/// Loading and live updates are driven by the view through ``load()`` from a
/// `.task(id:)`, so SwiftUI owns the lifetime: the work is cancelled on disappear
/// and restarted on reappear (or when ``reload()`` bumps ``reloadID``). There is
/// deliberately no view-model-owned `Task` — structured concurrency keeps the
/// stream tied to the view's lifetime with no manual cancellation.
///
/// The live ``MovieDetailsDependencies/streamMovie`` subscription is the single
/// source of truth for post-fetch movie mutations (including watchlist on/off):
/// ``toggleOnWatchlist()`` persists the change and the stream re-emits the updated
/// movie — it does not mutate ``viewState`` directly.
@Observable
@MainActor
public final class MovieDetailsViewModel {

    public typealias ViewSnapshot = MovieDetailsViewSnapshot

    private static let logger = Logger.movieDetails

    public private(set) var viewState: ViewState<ViewSnapshot>
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
        viewState: ViewState<ViewSnapshot> = .initial,
        isWatchlistEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) {
        self.movieID = movieID
        self.transitionID = transitionID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
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

    /// Fetches details, then observes live movie updates until cancelled.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
        await observeMovieUpdates()
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

        let isCastAndCrewEnabled = (try? dependencies.isCastAndCrewEnabled()) ?? false
        let isRecommendedMoviesEnabled = (try? dependencies.isRecommendedMoviesEnabled()) ?? false

        let snapshot: ViewSnapshot
        do {
            async let movie = dependencies.fetchMovie(movieID)
            async let recommendedMovies = isRecommendedMoviesEnabled
                ? dependencies.fetchRecommendedMovies(movieID) : []
            async let credits = isCastAndCrewEnabled
                ? dependencies.fetchCredits(movieID) : nil

            let resolvedCredits = try await credits
            snapshot = try await ViewSnapshot(
                movie: movie,
                recommendedMovies: recommendedMovies,
                castMembers: resolvedCredits?.castMembers ?? [],
                crewMembers: resolvedCredits?.crewMembers ?? []
            )
        } catch {
            Self.logger.error(
                "Failed fetching movie details: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
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
        guard case .ready(let snapshot) = viewState else {
            return
        }
        viewState = .ready(ViewSnapshot(
            movie: movie,
            recommendedMovies: snapshot.recommendedMovies,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers
        ))
    }

}

#if DEBUG
    public extension MovieDetailsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>,
            isWatchlistEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) -> MovieDetailsViewModel {
            MovieDetailsViewModel(
                movieID: viewState.content?.movie.id ?? 0,
                dependencies: .preview,
                navigator: NoOpMovieDetailsNavigator(),
                viewState: viewState,
                isWatchlistEnabled: isWatchlistEnabled,
                isIntelligenceEnabled: isIntelligenceEnabled,
                isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
            )
        }

    }
#endif
