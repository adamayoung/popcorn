//
//  AggregateCreditsDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct AggregateCreditsDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [AggregateCastMemberDetails]
    public let crewByDepartment: [AggregateCrewDepartmentGroup]

    public var crew: [AggregateCrewMemberDetails] {
        crewByDepartment.flatMap(\.members)
    }

    public init(
        id: Int,
        cast: [AggregateCastMemberDetails],
        crewByDepartment: [AggregateCrewDepartmentGroup]
    ) {
        self.id = id
        self.cast = cast
        self.crewByDepartment = crewByDepartment
    }

}
