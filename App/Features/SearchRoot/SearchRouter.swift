//
//  SearchRouter.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import MediaSearchFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import Observation
import PersonDetailsFeature
import TVEpisodeCastAndCrewFeature
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature

/// A pushed destination on the Search tab's navigation stack.
enum SearchRoute: Hashable {
    case movieDetails(id: Int, transitionID: String?)
    case tvSeriesDetails(id: Int)
    case tvSeasonDetails(tvSeriesID: Int, seasonNumber: Int)
    case tvEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
    case personDetails(id: Int)
    case movieCastAndCrew(movieID: Int)
    case tvSeriesCastAndCrew(tvSeriesID: Int)
    case tvEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
}

/// Owns the Search tab's push stack and the two intelligence modal presentations.
@Observable
@MainActor
final class SearchRouter {

    /// The push navigation stack, bound to the root's `NavigationStack(path:)`.
    var path: [SearchRoute] = []

    /// The currently presented movie intelligence chat, or `nil` when no modal is
    /// shown. Bound to the root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedMovieIntelligence: PresentedMovieIntelligence?

    /// The currently presented TV series intelligence chat, or `nil` when no modal
    /// is shown. Bound to the root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedTVSeriesIntelligence: PresentedTVSeriesIntelligence?

    init(
        path: [SearchRoute] = [],
        presentedMovieIntelligence: PresentedMovieIntelligence? = nil,
        presentedTVSeriesIntelligence: PresentedTVSeriesIntelligence? = nil
    ) {
        self.path = path
        self.presentedMovieIntelligence = presentedMovieIntelligence
        self.presentedTVSeriesIntelligence = presentedTVSeriesIntelligence
    }

}

/// Translates leaf-feature navigation requests into ``SearchRouter`` mutations.
///
/// Implements every navigating protocol reachable from the Search tab:
/// - the home pushes movie / TV series / person details (no `transitionID`)
/// - `*CastAndCrewNavigating.openPersonDetails(id:transitionID:)` drops the
///   `transitionID` (person details has none)
/// - `openMovieIntelligence(id:)` / `openTVSeriesIntelligence(id:)` present modals
///   instead of pushing
@MainActor
struct SearchRouterNavigator: MediaSearchNavigating, MovieDetailsNavigating,
    TVSeriesDetailsNavigating, TVSeasonDetailsNavigating, TVEpisodeDetailsNavigating,
    PersonDetailsNavigating, MovieCastAndCrewNavigating, TVSeriesCastAndCrewNavigating,
    TVEpisodeCastAndCrewNavigating {

    let router: SearchRouter

    // MARK: - MediaSearchNavigating

    func openMovieDetails(id: Int) {
        router.path.append(.movieDetails(id: id, transitionID: nil))
    }

    func openTVSeriesDetails(id: Int) {
        router.path.append(.tvSeriesDetails(id: id))
    }

    func openPersonDetails(id: Int) {
        router.path.append(.personDetails(id: id))
    }

    // MARK: - MovieDetailsNavigating

    func openMovieIntelligence(id: Int) {
        router.presentedMovieIntelligence = PresentedMovieIntelligence(movieID: id)
    }

    func openMovieCastAndCrew(movieID: Int) {
        router.path.append(.movieCastAndCrew(movieID: movieID))
    }

    // MARK: - TVSeriesDetailsNavigating

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

    // MARK: - Cast & Crew (Movie / TV Series / TV Episode)

    func openPersonDetails(id: Int, transitionID: String?) {
        // `transitionID` is dropped: person details has no transitionID-driven zoom.
        router.path.append(.personDetails(id: id))
    }

}
