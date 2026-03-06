//
//  CrewDepartment.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

public struct CrewDepartment: Equatable, Sendable {

    public let department: String
    public let members: [CrewMember]

    public init(department: String, members: [CrewMember]) {
        self.department = department
        self.members = members
    }

}

extension CrewDepartment {

    static var mocks: [CrewDepartment] {
        let allMembers = CrewMember.mocks
        let grouped = Dictionary(grouping: allMembers, by: \.department)
        let departmentOrder = ["Production"]
        return departmentOrder.compactMap { department in
            guard let members = grouped[department] else {
                return nil
            }
            return CrewDepartment(department: department, members: members)
        }
    }

}
