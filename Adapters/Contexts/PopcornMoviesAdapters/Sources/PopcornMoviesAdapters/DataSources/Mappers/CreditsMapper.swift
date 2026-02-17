//
//  CreditsMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct CreditsMapper {

    func map(_ dto: TMDb.ShowCredits) -> Credits {
        let castMapper = CastMemberMapper()
        let crewMapper = CrewMemberMapper()

        return Credits(
            id: dto.id,
            cast: dto.cast.map(castMapper.map),
            crew: dto.crew.map(crewMapper.map)
        )
    }

}
