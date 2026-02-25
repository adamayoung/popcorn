//
//  TVSeriesCreditsEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesCreditsEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var tvSeriesID: Int
    @Relationship(deleteRule: .cascade) var cast: [TVSeriesCastMemberEntity]
    @Relationship(deleteRule: .cascade) var crew: [TVSeriesCrewMemberEntity]
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        cast: [TVSeriesCastMemberEntity] = [],
        crew: [TVSeriesCrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.tvSeriesID = tvSeriesID
        self.cast = cast
        self.crew = crew
        self.cachedAt = cachedAt
    }

}
