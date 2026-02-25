//
//  CreditsEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct CreditsEntityMapper {

    func map(_ entity: TVSeriesCreditsEntity) -> Credits {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        let cast = entity.cast
            .map(castMapper.map)
            .sorted { $0.order < $1.order }

        let crew = entity.crew
            .map(crewMapper.map)

        return Credits(
            id: entity.tvSeriesID,
            cast: cast,
            crew: crew
        )
    }

    func compactMap(_ entity: TVSeriesCreditsEntity?) -> Credits? {
        guard let entity else {
            return nil
        }
        return map(entity)
    }

    func map(_ credits: Credits, tvSeriesID: Int) -> TVSeriesCreditsEntity {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        return TVSeriesCreditsEntity(
            tvSeriesID: tvSeriesID,
            cast: credits.cast.map { castMapper.map($0, tvSeriesID: tvSeriesID) },
            crew: credits.crew.map { crewMapper.map($0, tvSeriesID: tvSeriesID) }
        )
    }

    func map(_ credits: Credits, tvSeriesID: Int, to entity: TVSeriesCreditsEntity) {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        entity.cast = credits.cast.map { castMapper.map($0, tvSeriesID: tvSeriesID) }
        entity.crew = credits.crew.map { crewMapper.map($0, tvSeriesID: tvSeriesID) }
        entity.cachedAt = .now
    }

}
