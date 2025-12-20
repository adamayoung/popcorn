//
//  MediaPreview.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public enum MediaPreview: Identifiable, Equatable, Sendable {

    public var id: Int {
        switch self {
        case .movie(let movie):
            movie.id

        case .tvSeries(let tvSeries):
            tvSeries.id

        case .person(let person):
            person.id
        }
    }

    case movie(MoviePreview)
    case tvSeries(TVSeriesPreview)
    case person(PersonPreview)

}
