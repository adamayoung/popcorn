//
//  ExploreRouterNavigator+MovieDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import MovieDetailsFeature

extension ExploreRouterNavigator: MovieDetailsNavigating {

    func openPersonDetails(id: Int) {
        // Shared witness: also satisfies `TVSeriesDetailsNavigating` and
        // `TVEpisodeDetailsNavigating`. Pushes without a zoom (nil transitionID).
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

}
