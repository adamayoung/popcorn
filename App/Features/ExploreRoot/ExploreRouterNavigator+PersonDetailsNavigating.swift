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
/// the detail features), so this conformance needs no further members.
extension ExploreRouterNavigator: PersonDetailsNavigating {}
