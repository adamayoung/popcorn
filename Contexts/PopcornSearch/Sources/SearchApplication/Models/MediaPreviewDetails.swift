//
//  MediaPreviewDetails.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A polymorphic type representing detailed media preview information.
///
/// This enum provides a type-safe way to handle heterogeneous search results
/// containing movies, TV series, and people with their associated image URL sets.
/// Unlike ``MediaPreview``, this type includes fully resolved image URLs suitable
/// for display in the UI.
///
public enum MediaPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the media item.
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

    /// A movie preview with detailed image information.
    case movie(MoviePreviewDetails)

    /// A TV series preview with detailed image information.
    case tvSeries(TVSeriesPreviewDetails)

    /// A person preview with detailed image information.
    case person(PersonPreviewDetails)

}
