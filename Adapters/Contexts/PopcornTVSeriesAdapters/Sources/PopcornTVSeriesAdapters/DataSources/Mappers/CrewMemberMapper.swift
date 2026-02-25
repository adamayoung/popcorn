//
//  CrewMemberMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct CrewMemberMapper {

    func map(_ dto: TMDb.CrewMember) -> TVSeriesDomain.CrewMember {
        let genderMapper = GenderMapper()

        return TVSeriesDomain.CrewMember(
            id: dto.creditID,
            personID: dto.id,
            personName: dto.name,
            job: dto.job,
            profilePath: dto.profilePath,
            gender: genderMapper.compactMap(dto.gender) ?? .unknown,
            department: dto.department
        )
    }

}
