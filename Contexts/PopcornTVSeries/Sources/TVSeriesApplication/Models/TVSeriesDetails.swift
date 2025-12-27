//
//  TVSeriesDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public struct TVSeriesDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let tagline: String?
    public let overview: String
    public let numberOfSeasons: Int
    public let firstAirDate: Date?
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        tagline: String? = nil,
        overview: String,
        numberOfSeasons: Int,
        firstAirDate: Date? = nil,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.overview = overview
        self.numberOfSeasons = numberOfSeasons
        self.firstAirDate = firstAirDate
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
