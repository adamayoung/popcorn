//
//  CastMemberMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct CastMemberMapper {

    func map(_ dto: TMDb.CastMember) -> TVSeriesDomain.CastMember {
        let genderMapper = GenderMapper()

        return TVSeriesDomain.CastMember(
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
