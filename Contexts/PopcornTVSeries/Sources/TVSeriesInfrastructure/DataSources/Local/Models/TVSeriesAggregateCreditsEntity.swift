//
//  TVSeriesAggregateCreditsEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesAggregateCreditsEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var tvSeriesID: Int
    @Relationship(deleteRule: .cascade) var cast: [TVSeriesAggregateCastMemberEntity]
    @Relationship(deleteRule: .cascade) var crew: [TVSeriesAggregateCrewMemberEntity]
    var cachedAt: Date

    init(
        tvSeriesID: Int,
        cast: [TVSeriesAggregateCastMemberEntity] = [],
        crew: [TVSeriesAggregateCrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.tvSeriesID = tvSeriesID
        self.cast = cast
        self.crew = crew
        self.cachedAt = cachedAt
    }

}
