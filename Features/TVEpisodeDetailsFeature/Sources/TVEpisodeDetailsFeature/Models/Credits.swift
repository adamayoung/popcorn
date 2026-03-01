//
//  Credits.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct Credits: Identifiable, Equatable, Sendable {

    public let id: Int
    public let castMembers: [CastMember]
    public let crewMembers: [CrewMember]

    public init(
        id: Int,
        castMembers: [CastMember],
        crewMembers: [CrewMember]
    ) {
        self.id = id
        self.castMembers = castMembers
        self.crewMembers = crewMembers
    }

}

extension Credits {

    static var mock: Credits {
        Credits(
            id: 1396,
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks
        )
    }

}
