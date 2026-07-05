//
//  PersonMapper.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication

/// Maps a context ``PersonDetails`` to the feature's ``Person`` presentation model.
public struct PersonMapper {

    /// Creates a person mapper.
    public init() {}

    /// Maps a context ``PersonDetails`` to a presentation ``Person``.
    public func map(_ personDetails: PersonDetails) -> Person {
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
            profileURL: personDetails.profileURLSet?.detail,
            smallProfileURL: personDetails.profileURLSet?.thumbnail,
            initials: personDetails.initials
        )
    }

}
