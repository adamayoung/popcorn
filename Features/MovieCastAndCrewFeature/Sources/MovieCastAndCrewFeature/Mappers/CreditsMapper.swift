//
//  CreditsMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct CreditsMapper {

    func map(_ creditsDetails: CreditsDetails) -> Credits {
        Credits(
            id: creditsDetails.id,
            castMembers: creditsDetails.cast.map(map),
            crewByDepartment: creditsDetails.crewByDepartment.map(map)
        )
    }

    private func map(_ castMemberDetails: CastMemberDetails) -> CastMember {
        CastMember(
            id: castMemberDetails.id,
            personID: castMemberDetails.personID,
            characterName: castMemberDetails.characterName,
            personName: castMemberDetails.personName,
            profileURL: castMemberDetails.profileURLSet?.detail,
            initials: castMemberDetails.initials
        )
    }

    private func map(_ group: CrewDepartmentGroup) -> CrewDepartment {
        CrewDepartment(
            department: group.department,
            members: group.members.map(map)
        )
    }

    private func map(_ crewMemberDetails: CrewMemberDetails) -> CrewMember {
        CrewMember(
            id: crewMemberDetails.id,
            personID: crewMemberDetails.personID,
            personName: crewMemberDetails.personName,
            job: crewMemberDetails.job,
            profileURL: crewMemberDetails.profileURLSet?.detail,
            department: crewMemberDetails.department,
            initials: crewMemberDetails.initials
        )
    }

}
