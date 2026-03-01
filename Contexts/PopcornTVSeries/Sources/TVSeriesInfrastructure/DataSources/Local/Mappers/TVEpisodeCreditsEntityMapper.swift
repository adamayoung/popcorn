//
//  TVEpisodeCreditsEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVEpisodeCreditsEntityMapper {

    func map(_ entity: TVEpisodeCreditsEntity) -> Credits {
        let castMapper = TVEpisodeCastMemberEntityMapper()
        let crewMapper = TVEpisodeCrewMemberEntityMapper()

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

    func compactMap(_ entity: TVEpisodeCreditsEntity?) -> Credits? {
        guard let entity else {
            return nil
        }
        return map(entity)
    }

    func map(
        _ credits: Credits,
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> TVEpisodeCreditsEntity {
        let castMapper = TVEpisodeCastMemberEntityMapper()
        let crewMapper = TVEpisodeCrewMemberEntityMapper()

        return TVEpisodeCreditsEntity(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            cast: credits.cast.map {
                castMapper.map(
                    $0,
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            },
            crew: credits.crew.map {
                crewMapper.map(
                    $0,
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
            }
        )
    }

    func map(
        _ credits: Credits,
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        to entity: TVEpisodeCreditsEntity
    ) {
        let castMapper = TVEpisodeCastMemberEntityMapper()
        let crewMapper = TVEpisodeCrewMemberEntityMapper()

        entity.cast = credits.cast.map {
            castMapper.map(
                $0,
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        }
        entity.crew = credits.crew.map {
            crewMapper.map(
                $0,
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        }
        entity.cachedAt = .now
    }

}
