//
//  PersonMapper.swift
//  PersonDetailsFeature
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import PeopleApplication

struct PersonMapper {

    func map(_ personDetails: PersonDetails) -> Person {
        let gender: Gender = {
            switch personDetails.gender {
            case .female: return .female
            case .male: return .male
            case .other: return .other
            case .unknown: return .unknown
            }
        }()

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
