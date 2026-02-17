//
//  CastMemberDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct CastMemberDetailsMapper {

    func map(
        _ castMember: CastMember,
        imagesConfiguration: ImagesConfiguration
    ) -> CastMemberDetails {
        let profileURLSet = imagesConfiguration.profileURLSet(for: castMember.profilePath)

        return CastMemberDetails(
            id: castMember.id,
            personID: castMember.personID,
            characterName: castMember.characterName,
            personName: castMember.personName,
            profileURLSet: profileURLSet,
            gender: castMember.gender,
            order: castMember.order
        )
    }

}
