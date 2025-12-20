//
//  PersonMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleApplication

struct PersonMapper {

    func map(_ personDetails: PersonDetails) -> Person {
        let gender: Gender = switch personDetails.gender {
        case .female: .female
        case .male: .male
        case .other: .other
        case .unknown: .unknown
        }

        return Person(
            id: personDetails.id,
            name: personDetails.name,
            biography: personDetails.biography,
            knownForDepartment: personDetails.knownForDepartment,
            gender: gender,
            profileURL: personDetails.profileURLSet?.detail
        )
    }

}
