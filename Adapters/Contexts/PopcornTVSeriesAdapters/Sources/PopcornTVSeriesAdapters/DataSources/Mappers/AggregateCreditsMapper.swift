//
//  AggregateCreditsMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct AggregateCreditsMapper {

    func map(_ dto: TMDb.TVSeriesAggregateCredits) -> TVSeriesDomain.AggregateCredits {
        let castMapper = AggregateCastMemberMapper()
        let crewMapper = AggregateCrewMemberMapper()

        return TVSeriesDomain.AggregateCredits(
            id: dto.id,
            cast: dto.cast.map(castMapper.map),
            crew: dto.crew.map(crewMapper.map)
        )
    }

}
