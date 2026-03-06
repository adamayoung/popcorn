//
//  AggregateCrewDepartmentGroup.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

/// A group of aggregate crew members belonging to the same department, sorted by job priority.
public struct AggregateCrewDepartmentGroup: Equatable, Sendable {

    /// The name of the department (e.g., "Directing", "Production").
    public let department: String

    /// The aggregate crew members in this department, sorted by job priority.
    public let members: [AggregateCrewMemberDetails]

    public init(department: String, members: [AggregateCrewMemberDetails]) {
        self.department = department
        self.members = members
    }

}
