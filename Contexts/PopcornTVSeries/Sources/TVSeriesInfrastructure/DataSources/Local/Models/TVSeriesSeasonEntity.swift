//
//  TVSeriesSeasonEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesSeasonEntity: Equatable {

    @Attribute(.unique) var seasonID: Int
    var name: String
    var seasonNumber: Int
    var posterPath: URL?

    init(
        seasonID: Int,
        name: String,
        seasonNumber: Int,
        posterPath: URL? = nil
    ) {
        self.seasonID = seasonID
        self.name = name
        self.seasonNumber = seasonNumber
        self.posterPath = posterPath
    }

}
