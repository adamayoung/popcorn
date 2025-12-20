//
//  TransitionID.swift
//  Popcorn
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

    init(movie: MoviePreview, carouselType: MovieCarousel.CarouselType) {
        self.init(itemID: movie.id, context: carouselType.rawValue)
    }

    init(tvSeries: TVSeriesPreview, carouselType: TVSeriesCarousel.CarouselType) {
        self.init(itemID: tvSeries.id, context: carouselType.rawValue)
    }

    init(person: PersonPreview) {
        self.init(itemID: person.id)
    }

    var value: String {
        if let context {
            return "\(itemID)_\(context)"
        }

        return "\(itemID)"
    }

}
