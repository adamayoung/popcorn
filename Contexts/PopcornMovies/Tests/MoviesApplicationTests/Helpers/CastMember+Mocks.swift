//
//  CastMember+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

extension CastMember {

    static func mock(
        id: String = "1-cast",
        personID: Int = 1,
        characterName: String = "Dom Cobb",
        personName: String = "Leonardo DiCaprio",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Gender = .male,
        order: Int = 0
    ) -> CastMember {
        CastMember(
            id: id,
            personID: personID,
            characterName: characterName,
            personName: personName,
            profilePath: profilePath,
            gender: gender,
            order: order
        )
    }

    static var mocks: [CastMember] {
        [
            .mock(id: "1-cast", personID: 1, characterName: "Dom Cobb", personName: "Leonardo DiCaprio", order: 0),
            .mock(id: "2-cast", personID: 2, characterName: "Arthur", personName: "Joseph Gordon-Levitt", order: 1)
        ]
    }

}
