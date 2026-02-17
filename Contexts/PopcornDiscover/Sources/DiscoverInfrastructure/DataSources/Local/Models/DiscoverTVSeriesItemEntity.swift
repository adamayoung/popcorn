//
//  DiscoverTVSeriesItemEntity.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class DiscoverTVSeriesItemEntity: ModelExpirable {

    var sortIndex: Int
    var page: Int
    var filterKey: String?
    @Relationship var tvSeries: DiscoverTVSeriesPreviewEntity?
    var cachedAt: Date

    init(
        sortIndex: Int,
        page: Int,
        filterKey: String?,
        tvSeries: DiscoverTVSeriesPreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.sortIndex = sortIndex
        self.page = page
        self.filterKey = filterKey
        self.tvSeries = tvSeries
        self.cachedAt = cachedAt
    }

}
