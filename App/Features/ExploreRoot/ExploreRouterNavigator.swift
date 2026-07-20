//
//  ExploreRouterNavigator.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// Translates leaf-feature navigation requests into ``ExploreRouter`` mutations.
///
/// Implements every navigating protocol reachable from the Explore tab, with one
/// conformance per extension (see the `ExploreRouterNavigator+*Navigating` files):
/// - the home carousels forward `transitionID` to drive the zoom transition
///   (movie / TV series / person details)
/// - cast & crew screens push person details with no zoom — each
///   `*CastAndCrewViewModel.selectPerson` passes `transitionID: nil`, because its
///   transition source lives in a different namespace from the tab's zoom
/// - `openMovieIntelligence(id:)` / `openTVSeriesIntelligence(id:)` present modals
///   instead of pushing
///
/// Some requirements are shared across protocols and so have a single witness that
/// serves them all: `openPersonDetails(id:transitionID:)` (declared in the
/// `ExploreNavigating` extension) also satisfies the three `*CastAndCrewNavigating`
/// protocols, and `openPersonDetails(id:)` (declared in the `MovieDetailsNavigating`
/// extension) also satisfies `TVSeriesDetailsNavigating` and `TVEpisodeDetailsNavigating`.
@MainActor
struct ExploreRouterNavigator {

    let router: ExploreRouter

}
