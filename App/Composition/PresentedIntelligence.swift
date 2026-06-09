//
//  PresentedIntelligence.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// Identifies a presented movie intelligence chat by its movie id, for
/// `item`-based modal presentation. The MVVM replacement for a root coordinator's
/// `@Presents var movieIntelligence`.
struct PresentedMovieIntelligence: Identifiable, Hashable {
    let movieID: Int
    var id: Int {
        movieID
    }
}

/// Identifies a presented TV series intelligence chat by its TV series id, for
/// `item`-based modal presentation. The MVVM replacement for a root coordinator's
/// `@Presents var tvSeriesIntelligence`.
struct PresentedTVSeriesIntelligence: Identifiable, Hashable {
    let tvSeriesID: Int
    var id: Int {
        tvSeriesID
    }
}
