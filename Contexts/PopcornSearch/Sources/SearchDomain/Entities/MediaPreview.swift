//
//  MediaPreview.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A polymorphic type representing any searchable media item.
///
/// This enum provides a type-safe way to handle heterogeneous search results
/// containing movies, TV series, and people. It uses Swift's enum associated
/// values to encapsulate the specific preview type while providing a unified
/// interface through the `Identifiable` protocol.
///
public enum MediaPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the media item.
    ///
    /// This computed property extracts the ID from the associated value,
    /// allowing uniform access regardless of the underlying media type.
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

    /// A movie preview.
    case movie(MoviePreview)

    /// A TV series preview.
    case tvSeries(TVSeriesPreview)

    /// A person preview.
    case person(PersonPreview)

}
