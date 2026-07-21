//
//  ExploreRouterNavigator+DiscoverMoviesNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DiscoverMoviesFeature

/// This protocol's sole requirement, `openMovieDetails(id:transitionID:)`, is
/// witnessed by the `ExploreNavigating` extension. The discover grid makes each
/// poster a zoom source, so it forwards a `transitionID`.
extension ExploreRouterNavigator: DiscoverMoviesNavigating {}
