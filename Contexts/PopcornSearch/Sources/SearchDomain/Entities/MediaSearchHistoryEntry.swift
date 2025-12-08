//
//  MediaSearchHistoryEntry.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation

public enum MediaSearchHistoryEntry: Identifiable, Equatable, Sendable {

    public var id: Int {
        switch self {
        case .movie(let movie): movie.id
        case .tvSeries(let tvSeries): tvSeries.id
        case .person(let person): person.id
        }
    }

    public var timestamp: Date {
        switch self {
        case .movie(let movie): movie.timestamp
        case .tvSeries(let tvSeries): tvSeries.timestamp
        case .person(let person): person.timestamp
        }
    }

    case movie(MovieSearchHistoryEntry)
    case tvSeries(TVSeriesSearchHistoryEntry)
    case person(PersonSearchHistoryEntry)

}
