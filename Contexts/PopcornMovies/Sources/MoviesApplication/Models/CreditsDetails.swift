//
//  CreditsDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CreditsDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [CastMemberDetails]
    public let crewByDepartment: [CrewDepartmentGroup]

    public var crew: [CrewMemberDetails] {
        crewByDepartment.flatMap(\.members)
    }

    public init(
        id: Int,
        cast: [CastMemberDetails],
        crewByDepartment: [CrewDepartmentGroup]
    ) {
        self.id = id
        self.cast = cast
        self.crewByDepartment = crewByDepartment
    }

}
