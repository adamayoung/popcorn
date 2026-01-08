//
//  CastMember+Mocks.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain

extension CastMember {

    static func mock(
        id: String = "cast-1",
        personID: Int = 100,
        characterName: String = "Character Name",
        personName: String = "Actor Name",
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
            .mock(id: "cast-1", personID: 100, characterName: "Hero", personName: "Actor One", order: 0),
            .mock(id: "cast-2", personID: 101, characterName: "Villain", personName: "Actor Two", order: 1),
            .mock(id: "cast-3", personID: 102, characterName: "Sidekick", personName: "Actor Three", order: 2)
        ]
    }

}
