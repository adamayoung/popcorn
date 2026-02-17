//
//  CrewMember+Mocks.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain

extension CrewMember {

    static func mock(
        id: String = "crew-1",
        personID: Int = 200,
        personName: String = "Crew Name",
        job: String = "Director",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Gender = .female,
        department: String = "Directing"
    ) -> CrewMember {
        CrewMember(
            id: id,
            personID: personID,
            personName: personName,
            job: job,
            profilePath: profilePath,
            gender: gender,
            department: department
        )
    }

    static var mocks: [CrewMember] {
        [
            .mock(id: "crew-1", personID: 200, personName: "Director One", job: "Director", department: "Directing"),
            .mock(id: "crew-2", personID: 201, personName: "Writer One", job: "Writer", department: "Writing"),
            .mock(id: "crew-3", personID: 202, personName: "Producer One", job: "Producer", department: "Production")
        ]
    }

}
