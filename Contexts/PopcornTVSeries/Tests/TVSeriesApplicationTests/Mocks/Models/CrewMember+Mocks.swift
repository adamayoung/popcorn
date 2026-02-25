//
//  CrewMember+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

extension CrewMember {

    static func mock(
        id: String = "1-crew",
        personID: Int = 3,
        personName: String = "Christopher Storer",
        job: String = "Creator",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Gender = .male,
        department: String = "Production"
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
            .mock(
                id: "1-crew",
                personID: 3,
                personName: "Christopher Storer",
                job: "Creator"
            ),
            .mock(
                id: "2-crew",
                personID: 4,
                personName: "Joanna Calo",
                job: "Writer",
                department: "Writing"
            )
        ]
    }

}
