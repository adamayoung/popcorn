//
//  CastMemberMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct CastMemberMapper {

    func map(_ dto: TMDb.CastMember) -> MoviesDomain.CastMember {
        let genderMapper = GenderMapper()

        return MoviesDomain.CastMember(
            id: dto.creditID,
            personID: dto.id,
            characterName: dto.character,
            personName: dto.name,
            profilePath: dto.profilePath,
            gender: genderMapper.compactMap(dto.gender) ?? .unknown,
            order: dto.order
        )
    }

}
