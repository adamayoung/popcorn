//
//  ExploreRouter.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Observation

/// A pushed destination on the Explore tab's navigation stack.
enum ExploreRoute: Hashable {
    case trendingMovies
    case discoverMovies
    case popularMovies
    case movieDetails(id: Int, transitionID: String?)
    case tvSeriesDetails(id: Int, transitionID: String?)
    case tvSeasonDetails(tvSeriesID: Int, seasonNumber: Int)
    case tvEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
    case personDetails(id: Int, transitionID: String?)
    case personCredits(personID: Int)
    case movieCastAndCrew(movieID: Int)
    case tvSeriesCastAndCrew(tvSeriesID: Int)
    case tvEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
}

/// Owns the Explore tab's push stack and the two intelligence modal presentations.
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
