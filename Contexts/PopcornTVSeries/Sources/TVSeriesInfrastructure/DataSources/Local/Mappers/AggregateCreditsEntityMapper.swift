//
//  AggregateCreditsEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct AggregateCreditsEntityMapper {

    func map(_ entity: TVSeriesAggregateCreditsEntity) -> AggregateCredits {
        let castMapper = AggregateCastMemberEntityMapper()
        let crewMapper = AggregateCrewMemberEntityMapper()

        let cast = entity.cast
            .map(castMapper.map)
            .sorted { $0.totalEpisodeCount > $1.totalEpisodeCount }

        let crew = entity.crew
            .map(crewMapper.map)

        return AggregateCredits(
            id: entity.tvSeriesID,
            cast: cast,
            crew: crew
        )
    }

    func map(
        _ aggregateCredits: AggregateCredits,
        tvSeriesID: Int
    ) -> TVSeriesAggregateCreditsEntity {
        let castMapper = AggregateCastMemberEntityMapper()
        let crewMapper = AggregateCrewMemberEntityMapper()

        return TVSeriesAggregateCreditsEntity(
            tvSeriesID: tvSeriesID,
            cast: aggregateCredits.cast.map { castMapper.map($0, tvSeriesID: tvSeriesID) },
            crew: aggregateCredits.crew.map { crewMapper.map($0, tvSeriesID: tvSeriesID) }
        )
    }

    func map(
        _ aggregateCredits: AggregateCredits,
        tvSeriesID: Int,
        to entity: TVSeriesAggregateCreditsEntity
    ) {
        let castMapper = AggregateCastMemberEntityMapper()
        let crewMapper = AggregateCrewMemberEntityMapper()

        entity.cast = aggregateCredits.cast.map { castMapper.map($0, tvSeriesID: tvSeriesID) }
        entity.crew = aggregateCredits.crew.map { crewMapper.map($0, tvSeriesID: tvSeriesID) }
        entity.cachedAt = .now
    }

}
