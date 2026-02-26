//
//  AggregateCastMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct AggregateCastMemberEntityMapper {

    func map(_ entity: TVSeriesAggregateCastMemberEntity) -> AggregateCastMember {
        let genderMapper = GenderEntityMapper()

        let roles = entity.roles.map { role in
            CastRole(
                creditID: role.creditID,
                character: role.character,
                episodeCount: role.episodeCount
            )
        }

        return AggregateCastMember(
            id: entity.personID,
            name: entity.name,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            roles: roles,
            totalEpisodeCount: entity.totalEpisodeCount,
            initials: personInitials(from: entity.name)
        )
    }

    func map(
        _ castMember: AggregateCastMember,
        tvSeriesID: Int,
        order: Int
    ) -> TVSeriesAggregateCastMemberEntity {
        let genderMapper = GenderEntityMapper()

        let roles = castMember.roles.map { role in
            CastRoleValue(
                creditID: role.creditID,
                character: role.character,
                episodeCount: role.episodeCount
            )
        }

        return TVSeriesAggregateCastMemberEntity(
            tvSeriesID: tvSeriesID,
            personID: castMember.id,
            name: castMember.name,
            profilePath: castMember.profilePath,
            gender: genderMapper.map(castMember.gender),
            roles: roles,
            totalEpisodeCount: castMember.totalEpisodeCount,
            order: order
        )
    }

}
