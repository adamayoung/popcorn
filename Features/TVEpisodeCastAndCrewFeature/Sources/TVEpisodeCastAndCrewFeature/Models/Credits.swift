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
    public let crewByDepartment: [CrewDepartment]

    public var crewMembers: [CrewMember] {
        crewByDepartment.flatMap(\.members)
    }

    public init(
        id: Int,
        castMembers: [CastMember],
        crewByDepartment: [CrewDepartment]
    ) {
        self.id = id
        self.castMembers = castMembers
        self.crewByDepartment = crewByDepartment
    }

}

extension Credits {

    static var mock: Credits {
        Credits(
            id: 1396,
            castMembers: CastMember.mocks,
            crewByDepartment: CrewDepartment.mocks
        )
    }

}
