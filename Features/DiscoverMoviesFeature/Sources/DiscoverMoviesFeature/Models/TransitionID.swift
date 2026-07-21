//
//  TransitionID.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Identifies a zoom transition source, scoping it to the view that owns it.
///
/// The context matters: the Explore carousel publishes the same movies under the
/// `discover-movies` context, and that carousel is still mounted in the same
/// namespace while this grid is pushed on top of it. Sharing an identifier would
/// leave the zoom with two candidate sources, so the grid uses its own context.
struct TransitionID {

    /// The context used by the discover movies grid.
    static let gridContext = "discover-movies-grid"

    let itemID: Int
    let context: String?

    init(itemID: Int, context: String? = nil) {
        self.itemID = itemID
        self.context = context
    }

    init(movie: MoviePreview, context: String = TransitionID.gridContext) {
        self.init(itemID: movie.id, context: context)
    }

    var value: String {
        guard let context else {
            return "\(itemID)"
        }

        return "\(itemID)_\(context)"
    }

}
