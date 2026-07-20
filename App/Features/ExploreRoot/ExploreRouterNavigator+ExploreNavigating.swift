//
//  ExploreRouterNavigator+ExploreNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ExploreFeature

extension ExploreRouterNavigator: ExploreNavigating {

    func openTrendingMovies() {
        router.path.append(.trendingMovies)
    }

    func openMovieDetails(id: Int, transitionID: String?) {
        // The home carousel forwards its `transitionID` to drive the zoom transition.
        router.path.append(.movieDetails(id: id, transitionID: transitionID))
    }

    func openTVSeriesDetails(id: Int, transitionID: String?) {
        // The home carousel forwards its `transitionID` to drive the zoom transition.
        router.path.append(.tvSeriesDetails(id: id, transitionID: transitionID))
    }

    func openPersonDetails(id: Int, transitionID: String?) {
        // Forwards `transitionID` so the home people carousel zooms. Cast & crew
        // person rows reach this via the same `*CastAndCrewNavigating` requirement
        // but pass `transitionID: nil` (see each `*CastAndCrewViewModel.selectPerson`)
        // so they push without an (unmatched) zoom.
        router.path.append(.personDetails(id: id, transitionID: transitionID))
    }

}
