//
//  ExploreRouterNavigator+TVEpisodeCastAndCrewNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TVEpisodeCastAndCrewFeature

// This protocol's sole requirement, `openPersonDetails(id:transitionID:)`, is
// witnessed by the `ExploreNavigating` extension. Cast & crew rows pass
// `transitionID: nil`, so the person detail pushes without a zoom.
extension ExploreRouterNavigator: TVEpisodeCastAndCrewNavigating {}
