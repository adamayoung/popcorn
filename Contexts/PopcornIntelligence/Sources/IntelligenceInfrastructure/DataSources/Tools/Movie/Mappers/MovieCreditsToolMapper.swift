//
//  MovieCreditsToolMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

struct MovieCreditsToolMapper {

    func map(_ credits: Credits, limit: Int) -> MovieCreditsToolCredits {
        MovieCreditsToolCredits(
            id: credits.id,
            cast: credits.cast.prefix(limit).map(map),
            crew: credits.crew.prefix(limit).map(map)
        )
    }

    private func map(_ castMember: CastMember) -> MovieCreditsToolCastMember {
        MovieCreditsToolCastMember(
            id: castMember.id,
            personID: castMember.personID,
            personName: castMember.personName,
            characterName: castMember.characterName
        )
    }

    private func map(_ crewMember: CrewMember) -> MovieCreditsToolCrewMember {
        MovieCreditsToolCrewMember(
            id: crewMember.id,
            personID: crewMember.personID,
            personName: crewMember.personName,
            job: crewMember.job
        )
    }

}
