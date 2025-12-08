//
//  TVSeries.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation

public struct TVSeries: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?

    public init(
        id: Int,
        name: String,
        overview: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
    }

}
