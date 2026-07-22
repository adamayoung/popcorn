//
//  ExploreRouterNavigator+PersonCreditsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import PersonCreditsFeature

/// `PersonCreditsNavigating`'s `openMovieDetails(id:)` / `openTVSeriesDetails(id:)`
/// requirements are already satisfied by `ExploreRouterNavigator`'s
/// `MovieDetailsNavigating` / `TVSeriesDetailsNavigating` witnesses (shared across
/// the detail features), so this conformance needs no further members.
extension ExploreRouterNavigator: PersonCreditsNavigating {}
