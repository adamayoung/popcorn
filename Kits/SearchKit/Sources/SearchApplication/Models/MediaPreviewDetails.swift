//
//  MediaPreviewDetails.swift
//  SearchKit
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public enum MediaPreviewDetails: Identifiable, Equatable, Sendable {

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

    case movie(MoviePreviewDetails)
    case tvSeries(TVSeriesPreviewDetails)
    case person(PersonPreviewDetails)

}
