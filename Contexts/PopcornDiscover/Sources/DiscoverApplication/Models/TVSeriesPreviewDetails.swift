//
//  TVSeriesPreviewDetails.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public struct TVSeriesPreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let firstAirDate: Date
    public let genres: [Genre]
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        overview: String,
        firstAirDate: Date,
        genres: [Genre],
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
