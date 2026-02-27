//
//  TVSeriesImageCollectionEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesImageCollectionEntity: Equatable, ModelExpirable {

    @Attribute(.unique) var tvSeriesID: Int
    var posterPaths: [URL]
    var backdropPaths: [URL]
    var logoPaths: [URL]
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        posterPaths: [URL] = [],
        backdropPaths: [URL] = [],
        logoPaths: [URL] = [],
        cachedAt: Date = Date.now
    ) {
        self.tvSeriesID = tvSeriesID
        self.posterPaths = posterPaths
        self.backdropPaths = backdropPaths
        self.logoPaths = logoPaths
        self.cachedAt = cachedAt
    }

}
