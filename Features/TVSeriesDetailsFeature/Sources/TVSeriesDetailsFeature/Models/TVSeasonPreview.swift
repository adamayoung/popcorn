//
//  TVSeasonPreview.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeasonPreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let seasonNumber: Int
    public let name: String
    public let posterURL: URL?

    public init(
        id: Int,
        seasonNumber: Int,
        name: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.name = name
        self.posterURL = posterURL
    }

}
