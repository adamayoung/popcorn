//
//  CastMemberEntityMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct CastMemberEntityMapper {

    func map(_ entity: CastMemberEntity) -> CastMember {
        let genderMapper = GenderEntityMapper()
        return CastMember(
            id: entity.creditID,
            personID: entity.personID,
            characterName: entity.characterName,
            personName: entity.personName,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            order: entity.order,
            initials: personInitials(from: entity.personName)
        )
    }

    func map(_ castMember: CastMember, movieID: Int) -> CastMemberEntity {
        let genderMapper = GenderEntityMapper()
        return CastMemberEntity(
            creditID: castMember.id,
            movieID: movieID,
            personID: castMember.personID,
            characterName: castMember.characterName,
            personName: castMember.personName,
            profilePath: castMember.profilePath,
            gender: genderMapper.map(castMember.gender),
            order: castMember.order
        )
    }

    func map(_ castMember: CastMember, movieID: Int, to entity: CastMemberEntity) {
        let genderMapper = GenderEntityMapper()
        entity.movieID = movieID
        entity.personID = castMember.personID
        entity.characterName = castMember.characterName
        entity.personName = castMember.personName
        entity.profilePath = castMember.profilePath
        entity.gender = genderMapper.map(castMember.gender)
        entity.order = castMember.order
    }

}
