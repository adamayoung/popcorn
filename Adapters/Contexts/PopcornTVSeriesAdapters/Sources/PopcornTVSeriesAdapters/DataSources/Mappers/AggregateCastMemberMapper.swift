//
//  AggregateCastMemberMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct AggregateCastMemberMapper {

    func map(_ dto: TMDb.AggregateCastMember) -> TVSeriesDomain.AggregateCastMember {
        let genderMapper = GenderMapper()

        let roles = dto.roles.map { role in
            TVSeriesDomain.CastRole(
                creditID: role.creditID,
                character: role.character,
                episodeCount: role.episodeCount
            )
        }

        return TVSeriesDomain.AggregateCastMember(
            id: dto.id,
            name: dto.name,
            profilePath: dto.profilePath,
            gender: genderMapper.compactMap(dto.gender) ?? .unknown,
            roles: roles,
            totalEpisodeCount: dto.totalEpisodeCount
        )
    }

}
