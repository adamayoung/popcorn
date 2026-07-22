//
//  ExploreRouterNavigator+PersonDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import PersonDetailsFeature

/// `PersonDetailsNavigating`'s `openMovieDetails(id:)` / `openTVSeriesDetails(id:)`
/// requirements are already satisfied by `ExploreRouterNavigator`'s
/// `MovieDetailsNavigating` / `TVSeriesDetailsNavigating` witnesses (shared across
/// the detail features), so this conformance only adds the credits push.
extension ExploreRouterNavigator: PersonDetailsNavigating {

    func openPersonCredits(personID: Int) {
        router.path.append(.personCredits(personID: personID))
    }

}
