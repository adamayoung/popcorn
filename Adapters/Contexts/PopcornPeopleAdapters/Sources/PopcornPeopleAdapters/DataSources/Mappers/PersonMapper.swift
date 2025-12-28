//
//  PersonMapper.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import TMDb

///
/// A mapper that converts TMDb person data to the domain model.
///
struct PersonMapper {

    ///
    /// Maps a TMDb person object to a domain person entity.
    ///
    /// - Parameter tmdbPerson: The TMDb person object to map.
    ///
    /// - Returns: A ``PeopleDomain.Person`` entity populated with the TMDb data.
    ///
    func map(_ tmdbPerson: TMDb.Person) -> PeopleDomain.Person {
        PeopleDomain.Person(
            id: tmdbPerson.id,
            name: tmdbPerson.name,
            biography: tmdbPerson.biography ?? "",
            knownForDepartment: tmdbPerson.knownForDepartment ?? "",
            gender: map(tmdbPerson.gender),
            profilePath: tmdbPerson.profilePath
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
