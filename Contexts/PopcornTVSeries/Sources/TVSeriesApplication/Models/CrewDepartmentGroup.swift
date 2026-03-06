//
//  CrewDepartmentGroup.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

/// A group of crew members belonging to the same department, sorted by job priority.
public struct CrewDepartmentGroup: Equatable, Sendable {

    /// The name of the department (e.g., "Directing", "Production").
    public let department: String

    /// The crew members in this department, sorted by job priority.
    public let members: [CrewMemberDetails]

    public init(department: String, members: [CrewMemberDetails]) {
        self.department = department
        self.members = members
    }

}
