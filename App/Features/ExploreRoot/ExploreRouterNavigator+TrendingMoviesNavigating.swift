//
//  ExploreRouterNavigator+TrendingMoviesNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TrendingMoviesFeature

/// This protocol's sole requirement, `openMovieDetails(id:)`, is witnessed by the
/// `MovieDetailsNavigating` extension. Trending rows push without a zoom, so they
/// pass no `transitionID`.
extension ExploreRouterNavigator: TrendingMoviesNavigating {}
