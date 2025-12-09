//
//  DiscoverMovieItemEntity.swift
//  PopcornDiscover
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import SwiftData

@Model
final class DiscoverMovieItemEntity: ModelExpirable {

    var sortIndex: Int
    var page: Int
    var filterKey: String?
    @Relationship var movie: DiscoverMoviePreviewEntity?
    var cachedAt: Date

    init(
        sortIndex: Int,
        page: Int,
        filterKey: String?,
        movie: DiscoverMoviePreviewEntity,
        cachedAt: Date = Date.now
    ) {
        self.sortIndex = sortIndex
        self.page = page
        self.filterKey = filterKey
        self.movie = movie
        self.cachedAt = cachedAt
    }

}
