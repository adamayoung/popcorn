//
//  TVEpisodeCastMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVEpisodeCastMemberEntityMapper {

    func map(_ entity: TVEpisodeCastMemberEntity) -> CastMember {
        let genderMapper = GenderEntityMapper()
        return CastMember(
            id: entity.creditID,
            personID: entity.personID,
            characterName: entity.characterName,
            personName: entity.personName,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            order: entity.order,
            initials: PersonInitials.resolve(from: entity.personName)
        )
    }

    func map(
        _ castMember: CastMember,
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> TVEpisodeCastMemberEntity {
        let genderMapper = GenderEntityMapper()
        return TVEpisodeCastMemberEntity(
            creditID: castMember.id,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            personID: castMember.personID,
            characterName: castMember.characterName,
            personName: castMember.personName,
            profilePath: castMember.profilePath,
            gender: genderMapper.map(castMember.gender),
            order: castMember.order
        )
    }

}
