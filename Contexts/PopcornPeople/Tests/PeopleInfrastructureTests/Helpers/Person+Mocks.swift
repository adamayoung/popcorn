//
//  Person+Mocks.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

extension Person {

    static func mock(
        id: Int = 1,
        name: String = "Tom Hanks",
        biography: String = "A renowned American actor and filmmaker.",
        knownForDepartment: String = "Acting",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/profile.jpg")
    ) -> Person {
        Person(
            id: id,
            name: name,
            biography: biography,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath
        )
    }

}
