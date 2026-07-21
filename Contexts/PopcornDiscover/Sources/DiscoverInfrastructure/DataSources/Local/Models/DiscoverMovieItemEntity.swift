//
//  DiscoverMovieItemEntity.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class DiscoverMovieItemEntity: ModelExpirable {

    var sortIndex: Int
    var page: Int
    var totalPages: Int?
    var filterKey: String?
    @Relationship var movie: DiscoverMoviePreviewEntity?
    var cachedAt: Date

    init(
        sortIndex: Int,
        page: Int,
        totalPages: Int? = nil,
        filterKey: String?,
        movie: DiscoverMoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.sortIndex = sortIndex
        self.page = page
        self.totalPages = totalPages
        self.filterKey = filterKey
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
