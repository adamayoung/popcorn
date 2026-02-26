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
            .sorted { $0.order < $1.order }
            .map(castMapper.map)

        let crew = entity.crew
            .sorted { $0.order < $1.order }
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
            cast: aggregateCredits.cast.enumerated().map { index, member in
                castMapper.map(member, tvSeriesID: tvSeriesID, order: index)
            },
            crew: aggregateCredits.crew.enumerated().map { index, member in
                crewMapper.map(member, tvSeriesID: tvSeriesID, order: index)
            }
        )
    }

    func map(
        _ aggregateCredits: AggregateCredits,
        tvSeriesID: Int,
        to entity: TVSeriesAggregateCreditsEntity
    ) {
        let castMapper = AggregateCastMemberEntityMapper()
        let crewMapper = AggregateCrewMemberEntityMapper()

        entity.cast = aggregateCredits.cast.enumerated().map { index, member in
            castMapper.map(member, tvSeriesID: tvSeriesID, order: index)
        }
        entity.crew = aggregateCredits.crew.enumerated().map { index, member in
            crewMapper.map(member, tvSeriesID: tvSeriesID, order: index)
        }
        entity.cachedAt = .now
    }

}
