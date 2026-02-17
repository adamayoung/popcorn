//
//  CrewMemberMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct CrewMemberMapper {

    func map(_ dto: TMDb.CrewMember) -> MoviesDomain.CrewMember {
        let genderMapper = GenderMapper()

        return MoviesDomain.CrewMember(
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
