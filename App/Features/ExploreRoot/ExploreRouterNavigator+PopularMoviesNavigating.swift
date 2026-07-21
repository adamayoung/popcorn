//
//  ExploreRouterNavigator+PopularMoviesNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import PopularMoviesFeature

/// This protocol's sole requirement, `openMovieDetails(id:transitionID:)`, is
/// witnessed by the `ExploreNavigating` extension. The popular grid makes each
/// poster a zoom source, so it forwards a `transitionID`.
extension ExploreRouterNavigator: PopularMoviesNavigating {}
