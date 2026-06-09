//
//  ExploreRouter.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ExploreFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import Observation
import PersonDetailsFeature
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature

/// A pushed destination on the Explore tab's navigation stack. The MVVM
/// replacement for `ExploreRootFeature`'s `StackState<Path.State>` cases.
enum ExploreRoute: Hashable {
    case movieDetails(id: Int, transitionID: String?)
    case tvSeriesDetails(id: Int, transitionID: String?)
    case tvSeasonDetails(tvSeriesID: Int, seasonNumber: Int)
    case tvEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
    case personDetails(id: Int, transitionID: String?)
    case movieCastAndCrew(movieID: Int)
    case tvSeriesCastAndCrew(tvSeriesID: Int)
    case tvEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
}

/// Owns the Explore tab's push stack and modal presentations. The MVVM replacement
/// for `ExploreRootFeature`'s `StackState<Path.State>` + the two `@Presents`
/// intelligence presentations.
@Observable
@MainActor
final class ExploreRouter {

    /// The push navigation stack, bound to the root's `NavigationStack(path:)`.
    var path: [ExploreRoute] = []

    /// The currently presented movie intelligence chat, or `nil` when no modal is
    /// shown. Bound to the root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedMovieIntelligence: PresentedMovieIntelligence?

    /// The currently presented TV series intelligence chat, or `nil` when no modal
    /// is shown. Bound to the root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedTVSeriesIntelligence: PresentedTVSeriesIntelligence?

    init(
        path: [ExploreRoute] = [],
        presentedMovieIntelligence: PresentedMovieIntelligence? = nil,
        presentedTVSeriesIntelligence: PresentedTVSeriesIntelligence? = nil
    ) {
        self.path = path
        self.presentedMovieIntelligence = presentedMovieIntelligence
        self.presentedTVSeriesIntelligence = presentedTVSeriesIntelligence
    }

}

/// Translates leaf-feature navigation requests into ``ExploreRouter`` mutations.
///
/// Implements every navigating protocol reachable from the Explore tab. Mirrors
/// `ExploreRootFeature`'s reducer mapping exactly:
/// - the home pushes movie / TV series details (forwarding `transitionID`) and
///   person details (dropping `transitionID` — the route carries none)
/// - `*CastAndCrewNavigating.openPersonDetails(id:transitionID:)` drops the
///   `transitionID` (person details has none)
/// - `openMovieIntelligence(id:)` / `openTVSeriesIntelligence(id:)` present modals
///   instead of pushing
@MainActor
struct ExploreRouterNavigator: ExploreNavigating, MovieDetailsNavigating,
    TVSeriesDetailsNavigating, TVSeasonDetailsNavigating, TVEpisodeDetailsNavigating,
    PersonDetailsNavigating, MovieCastAndCrewNavigating, TVSeriesCastAndCrewNavigating,
    TVEpisodeCastAndCrewNavigating {

    let router: ExploreRouter

    // MARK: - ExploreNavigating (home)

    func openMovieDetails(id: Int, transitionID: String?) {
        // The home carousel forwards its `transitionID` to drive the zoom transition.
        router.path.append(.movieDetails(id: id, transitionID: transitionID))
    }

    func openTVSeriesDetails(id: Int, transitionID: String?) {
        // The home carousel forwards its `transitionID` to drive the zoom transition.
        router.path.append(.tvSeriesDetails(id: id, transitionID: transitionID))
    }

    func openPersonDetails(id: Int, transitionID: String?) {
        // Forward `transitionID`; only the home people carousel shares the per-tab
        // namespace, so cast & crew rows (which own their namespace) won't actually
        // zoom — reproducing the old behaviour (home person zoom; cast & crew none).
        router.path.append(.personDetails(id: id, transitionID: transitionID))
    }

    // MARK: - MovieDetailsNavigating

    func openPersonDetails(id: Int) {
        router.path.append(.personDetails(id: id, transitionID: nil))
    }

    func openMovieDetails(id: Int) {
        router.path.append(.movieDetails(id: id, transitionID: nil))
    }

    func openMovieIntelligence(id: Int) {
        router.presentedMovieIntelligence = PresentedMovieIntelligence(movieID: id)
    }

    func openMovieCastAndCrew(movieID: Int) {
        router.path.append(.movieCastAndCrew(movieID: movieID))
    }

    // MARK: - TVSeriesDetailsNavigating

    func openTVSeriesDetails(id: Int) {
        router.path.append(.tvSeriesDetails(id: id, transitionID: nil))
    }

    func openTVSeriesIntelligence(id: Int) {
        router.presentedTVSeriesIntelligence = PresentedTVSeriesIntelligence(tvSeriesID: id)
    }

    func openSeasonDetails(tvSeriesID: Int, seasonNumber: Int) {
        router.path.append(
            .tvSeasonDetails(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
        )
    }

    func openTVSeriesCastAndCrew(tvSeriesID: Int) {
        router.path.append(.tvSeriesCastAndCrew(tvSeriesID: tvSeriesID))
    }

    // MARK: - TVSeasonDetailsNavigating

    func openEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        router.path.append(
            .tvEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

    // MARK: - TVEpisodeDetailsNavigating

    func openTVEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        router.path.append(
            .tvEpisodeCastAndCrew(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

}
