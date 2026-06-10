//
//  WatchlistRouter.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import MovieCastAndCrewFeature
import MovieDetailsFeature
import Observation
import PersonDetailsFeature
import WatchlistFeature

/// A pushed destination on the Watchlist tab's navigation stack.
enum WatchlistRoute: Hashable {
    case movieDetails(id: Int, transitionID: String?)
    case personDetails(id: Int)
    case movieCastAndCrew(movieID: Int)
}

/// Owns the Watchlist tab's push stack and the movie intelligence modal presentation.
@Observable
@MainActor
final class WatchlistRouter {

    /// The push navigation stack, bound to the root's `NavigationStack(path:)`.
    var path: [WatchlistRoute] = []

    /// The currently presented movie intelligence chat, or `nil` when no modal is
    /// shown. Bound to the root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedMovieIntelligence: PresentedMovieIntelligence?

    init(
        path: [WatchlistRoute] = [],
        presentedMovieIntelligence: PresentedMovieIntelligence? = nil
    ) {
        self.path = path
        self.presentedMovieIntelligence = presentedMovieIntelligence
    }

}

/// Translates leaf-feature navigation requests into ``WatchlistRouter`` mutations.
///
/// Implements every navigating protocol reachable from the Watchlist tab:
/// - the home's `movieDetails(id, transitionID)` forwards the `transitionID` (zoom)
/// - `MovieDetailsNavigating.openMovieDetails(id:)` pushes with no `transitionID`
/// - `MovieCastAndCrewNavigating.openPersonDetails(id:transitionID:)` drops the
///   `transitionID` (person details has none)
/// - `openMovieIntelligence(id:)` presents a modal instead of pushing
@MainActor
struct WatchlistRouterNavigator: WatchlistNavigating, MovieDetailsNavigating,
PersonDetailsNavigating, MovieCastAndCrewNavigating {

    let router: WatchlistRouter

    // MARK: - WatchlistNavigating

    func openMovieDetails(id: Int, transitionID: String?) {
        router.path.append(.movieDetails(id: id, transitionID: transitionID))
    }

    // MARK: - MovieDetailsNavigating

    func openMovieDetails(id: Int) {
        router.path.append(.movieDetails(id: id, transitionID: nil))
    }

    func openPersonDetails(id: Int) {
        router.path.append(.personDetails(id: id))
    }

    func openMovieCastAndCrew(movieID: Int) {
        router.path.append(.movieCastAndCrew(movieID: movieID))
    }

    func openMovieIntelligence(id: Int) {
        router.presentedMovieIntelligence = PresentedMovieIntelligence(movieID: id)
    }

    // MARK: - MovieCastAndCrewNavigating

    func openPersonDetails(id: Int, transitionID: String?) {
        // `transitionID` is dropped: person details has no transitionID-driven zoom.
        router.path.append(.personDetails(id: id))
    }

}
