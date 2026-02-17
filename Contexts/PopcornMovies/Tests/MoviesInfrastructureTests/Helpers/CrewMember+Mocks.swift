//
//  CrewMember+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

extension CrewMember {

    static func mock(
        id: String = "1-crew",
        personID: Int = 3,
        personName: String = "Christopher Nolan",
        job: String = "Director",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Gender = .male,
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
            .mock(id: "1-crew", personID: 3, personName: "Christopher Nolan", job: "Director"),
            .mock(id: "2-crew", personID: 4, personName: "Hans Zimmer", job: "Composer", department: "Sound")
        ]
    }

}
