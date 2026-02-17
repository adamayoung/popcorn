//
//  CrewMemberDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct CrewMemberDetailsMapper {

    func map(
        _ crewMember: CrewMember,
        imagesConfiguration: ImagesConfiguration
    ) -> CrewMemberDetails {
        let profileURLSet = imagesConfiguration.profileURLSet(for: crewMember.profilePath)

        return CrewMemberDetails(
            id: crewMember.id,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job,
            profileURLSet: profileURLSet,
            gender: crewMember.gender,
            department: crewMember.department
        )
    }

}
