//
//  CastMember+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

extension CastMember {

    static func mock(
        id: String = "1-cast",
        personID: Int = 1,
        characterName: String = "Carmy Berzatto",
        personName: String = "Jeremy Allen White",
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
            .mock(
                id: "1-cast",
                personID: 1,
                characterName: "Carmy Berzatto",
                personName: "Jeremy Allen White",
                order: 0
            ),
            .mock(
                id: "2-cast",
                personID: 2,
                characterName: "Sydney Adamu",
                personName: "Ayo Edebiri",
                order: 1
            )
        ]
    }

}
