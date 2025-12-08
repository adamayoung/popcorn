//
//  PersonDetailsMapper.swift
//  PopcornPeople
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation
import PeopleDomain

struct PersonDetailsMapper {

    func map(_ person: Person, imagesConfiguration: ImagesConfiguration) -> PersonDetails {
        let profileURLSet = imagesConfiguration.posterURLSet(for: person.profilePath)

        return PersonDetails(
            id: person.id,
            name: person.name,
            biography: person.biography,
            knownForDepartment: person.knownForDepartment,
            gender: person.gender,
            profileURLSet: profileURLSet
        )
    }

}
