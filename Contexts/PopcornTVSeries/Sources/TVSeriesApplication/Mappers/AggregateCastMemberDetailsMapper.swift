//
//  AggregateCastMemberDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct AggregateCastMemberDetailsMapper {

    func map(
        _ castMember: AggregateCastMember,
        imagesConfiguration: ImagesConfiguration
    ) -> AggregateCastMemberDetails {
        let profileURLSet = imagesConfiguration.profileURLSet(for: castMember.profilePath)

        let roles = castMember.roles.map { role in
            CastRoleDetails(
                creditID: role.creditID,
                character: role.character,
                episodeCount: role.episodeCount
            )
        }

        return AggregateCastMemberDetails(
            id: castMember.id,
            name: castMember.name,
            profileURLSet: profileURLSet,
            gender: castMember.gender,
            roles: roles,
            totalEpisodeCount: castMember.totalEpisodeCount
        )
    }

}
