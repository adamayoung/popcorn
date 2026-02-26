//
//  PersonMapper.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import TMDb

struct PersonMapper {

    func map(_ tmdbPerson: TMDb.Person) -> PeopleDomain.Person {
        PeopleDomain.Person(
            id: tmdbPerson.id,
            name: tmdbPerson.name,
            biography: tmdbPerson.biography ?? "",
            knownForDepartment: tmdbPerson.knownForDepartment ?? "",
            gender: map(tmdbPerson.gender),
            profilePath: tmdbPerson.profilePath,
            initials: personInitials(from: tmdbPerson.name)
        )
    }

    private func map(_ gender: TMDb.Gender) -> CoreDomain.Gender {
        switch gender {
        case .unknown: .unknown
        case .female: .female
        case .male: .male
        case .other: .other
        }
    }

}
