//
//  CrewMemberEntityMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct CrewMemberEntityMapper {

    func map(_ entity: CrewMemberEntity) -> CrewMember {
        let genderMapper = GenderEntityMapper()
        return CrewMember(
            id: entity.creditID,
            personID: entity.personID,
            personName: entity.personName,
            job: entity.job,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            department: entity.department,
            initials: personInitials(from: entity.personName)
        )
    }

    func map(_ crewMember: CrewMember, movieID: Int) -> CrewMemberEntity {
        let genderMapper = GenderEntityMapper()
        return CrewMemberEntity(
            creditID: crewMember.id,
            movieID: movieID,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job,
            profilePath: crewMember.profilePath,
            gender: genderMapper.map(crewMember.gender),
            department: crewMember.department
        )
    }

    func map(_ crewMember: CrewMember, movieID: Int, to entity: CrewMemberEntity) {
        let genderMapper = GenderEntityMapper()
        entity.movieID = movieID
        entity.personID = crewMember.personID
        entity.personName = crewMember.personName
        entity.job = crewMember.job
        entity.profilePath = crewMember.profilePath
        entity.gender = genderMapper.map(crewMember.gender)
        entity.department = crewMember.department
    }

}
