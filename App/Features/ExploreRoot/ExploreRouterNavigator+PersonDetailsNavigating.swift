//
//  ExploreRouterNavigator+PersonDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import PersonDetailsFeature

/// `PersonDetailsNavigating` is a marker protocol with no requirements — person
/// details is a leaf screen. The conformance exists so the coordinator has a
/// consistent injection point across the detail features.
extension ExploreRouterNavigator: PersonDetailsNavigating {}
