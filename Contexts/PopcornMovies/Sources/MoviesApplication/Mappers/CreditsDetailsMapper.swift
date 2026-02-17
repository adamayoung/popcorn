//
//  CreditsDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct CreditsDetailsMapper {

    func map(
        _ credits: Credits,
        imagesConfiguration: ImagesConfiguration
    ) -> CreditsDetails {
        let castMapper = CastMemberDetailsMapper()
        let crewMapper = CrewMemberDetailsMapper()

        return CreditsDetails(
            id: credits.id,
            cast: credits.cast.map { castMapper.map($0, imagesConfiguration: imagesConfiguration) },
            crew: credits.crew.map { crewMapper.map($0, imagesConfiguration: imagesConfiguration) }
        )
    }

}
