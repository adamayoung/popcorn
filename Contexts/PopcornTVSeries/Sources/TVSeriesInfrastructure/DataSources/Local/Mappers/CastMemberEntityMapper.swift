//
//  CastMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct CastMemberEntityMapper {

    func map(_ entity: TVSeriesCastMemberEntity) -> CastMember {
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

    func map(_ castMember: CastMember, tvSeriesID: Int) -> TVSeriesCastMemberEntity {
        let genderMapper = GenderEntityMapper()
        return TVSeriesCastMemberEntity(
            creditID: castMember.id,
            tvSeriesID: tvSeriesID,
            personID: castMember.personID,
            characterName: castMember.characterName,
            personName: castMember.personName,
            profilePath: castMember.profilePath,
            gender: genderMapper.map(castMember.gender),
            order: castMember.order
        )
    }

    func map(_ castMember: CastMember, tvSeriesID: Int, to entity: TVSeriesCastMemberEntity) {
        let genderMapper = GenderEntityMapper()
        entity.tvSeriesID = tvSeriesID
        entity.personID = castMember.personID
        entity.characterName = castMember.characterName
        entity.personName = castMember.personName
        entity.profilePath = castMember.profilePath
        entity.gender = genderMapper.map(castMember.gender)
        entity.order = castMember.order
    }

}
