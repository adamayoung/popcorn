//
//  TransitionID.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

struct TransitionID {

    let itemID: Int
    let context: String?

    init(itemID: Int, context: String? = nil) {
        self.itemID = itemID
        self.context = context
    }

    init(movie: MoviePreview, context: String) {
        self.init(itemID: movie.id, context: context)
    }

    init(tvSeries: TVSeriesPreview, context: String) {
        self.init(itemID: tvSeries.id, context: context)
    }

    init(person: PersonPreview, context: String) {
        self.init(itemID: person.id, context: context)
    }

    var value: String {
        if let context {
            return "\(itemID)_\(context)"
        }

        return "\(itemID)"
    }

}
