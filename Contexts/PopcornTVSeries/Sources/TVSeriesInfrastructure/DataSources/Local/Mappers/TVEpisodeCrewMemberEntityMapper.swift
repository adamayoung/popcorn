//
//  TVEpisodeCrewMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVEpisodeCrewMemberEntityMapper {

    func map(_ entity: TVEpisodeCrewMemberEntity) -> CrewMember {
        let genderMapper = GenderEntityMapper()
        return CrewMember(
            id: entity.creditID,
            personID: entity.personID,
            personName: entity.personName,
            job: entity.job,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            department: entity.department,
            initials: PersonInitials.resolve(from: entity.personName)
        )
    }

    func map(
        _ crewMember: CrewMember,
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) -> TVEpisodeCrewMemberEntity {
        let genderMapper = GenderEntityMapper()
        return TVEpisodeCrewMemberEntity(
            creditID: crewMember.id,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job,
            profilePath: crewMember.profilePath,
            gender: genderMapper.map(crewMember.gender),
            department: crewMember.department
        )
    }

}
