//
//  MediaSearchHistoryEntry.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A polymorphic type representing a media item in the search history.
///
/// This enum provides a type-safe way to store heterogeneous search history
/// containing movies, TV series, and people. It uses Swift's enum associated
/// values to encapsulate the specific history entry type while providing
/// unified access to common properties like ID and timestamp.
///
public enum MediaSearchHistoryEntry: Identifiable, Equatable, Sendable {

    /// The unique identifier for the media item.
    ///
    /// This computed property extracts the ID from the associated value,
    /// allowing uniform access regardless of the underlying media type.
    public var id: Int {
        switch self {
        case .movie(let movie): movie.id
        case .tvSeries(let tvSeries): tvSeries.id
        case .person(let person): person.id
        }
    }

    /// The timestamp when this item was searched for.
    ///
    /// This computed property extracts the timestamp from the associated value,
    /// enabling chronological sorting of search history across all media types.
    public var timestamp: Date {
        switch self {
        case .movie(let movie): movie.timestamp
        case .tvSeries(let tvSeries): tvSeries.timestamp
        case .person(let person): person.timestamp
        }
    }

    /// A movie search history entry.
    case movie(MovieSearchHistoryEntry)

    /// A TV series search history entry.
    case tvSeries(TVSeriesSearchHistoryEntry)

    /// A person search history entry.
    case person(PersonSearchHistoryEntry)

}
