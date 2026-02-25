//
//  CrewMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct CrewMemberEntityMapper {

    func map(_ entity: TVSeriesCrewMemberEntity) -> CrewMember {
        let genderMapper = GenderEntityMapper()
        return CrewMember(
            id: entity.creditID,
            personID: entity.personID,
            personName: entity.personName,
            job: entity.job,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            department: entity.department
        )
    }

    func map(_ crewMember: CrewMember, tvSeriesID: Int) -> TVSeriesCrewMemberEntity {
        let genderMapper = GenderEntityMapper()
        return TVSeriesCrewMemberEntity(
            creditID: crewMember.id,
            tvSeriesID: tvSeriesID,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job,
            profilePath: crewMember.profilePath,
            gender: genderMapper.map(crewMember.gender),
            department: crewMember.department
        )
    }

    func map(_ crewMember: CrewMember, tvSeriesID: Int, to entity: TVSeriesCrewMemberEntity) {
        let genderMapper = GenderEntityMapper()
        entity.tvSeriesID = tvSeriesID
        entity.personID = crewMember.personID
        entity.personName = crewMember.personName
        entity.job = crewMember.job
        entity.profilePath = crewMember.profilePath
        entity.gender = genderMapper.map(crewMember.gender)
        entity.department = crewMember.department
    }

}
