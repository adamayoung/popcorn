//
//  CreditsMapper.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

struct CreditsMapper {

    func map(_ creditsDetails: MoviesApplication.CreditsDetails) -> Credits {
        Credits(
            id: creditsDetails.id,
            cast: creditsDetails.cast.map(map),
            crew: creditsDetails.crew.map(map)
        )
    }

    private func map(_ castMember: CastMemberDetails) -> CastMember {
        CastMember(
            id: castMember.id,
            personID: castMember.personID,
            characterName: castMember.characterName,
            personName: castMember.personName,
            profilePath: castMember.profileURLSet?.path,
            gender: castMember.gender,
            order: castMember.order
        )
    }

    private func map(_ crewMember: CrewMemberDetails) -> CrewMember {
        CrewMember(
            id: crewMember.id,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job,
            profilePath: crewMember.profileURLSet?.path,
            gender: crewMember.gender,
            department: crewMember.department
        )
    }

}
