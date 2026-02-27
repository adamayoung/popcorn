//
//  CrewSection.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct CrewSection: View {

    let crewByDepartment: [String: [CrewMember]]
    let transitionNamespace: Namespace.ID?
    let didSelectPerson: (Int, String?) -> Void

    /// TMDb department names are always returned in English, so this comparison is safe.
    private static let departmentPriority = [
        "Directing", "Writing", "Production", "Camera", "Editing", "Sound", "Art"
    ]

    private var sortedDepartments: [String] {
        crewByDepartment.keys.sorted { lhs, rhs in
            let lhsIndex = Self.departmentPriority.firstIndex(of: lhs) ?? Int.max
            let rhsIndex = Self.departmentPriority.firstIndex(of: rhs) ?? Int.max
            if lhsIndex != rhsIndex {
                return lhsIndex < rhsIndex
            }
            return lhs < rhs
        }
    }

    var body: some View {
        ForEach(sortedDepartments, id: \.self) { department in
            Section {
                ForEach(crewByDepartment[department, default: []]) { member in
                    Button {
                        didSelectPerson(member.id, String(member.id))
                    } label: {
                        CrewMemberRow(member: member, transitionNamespace: transitionNamespace)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(verbatim: department)
            }
        }
    }

}

#Preview {
    List {
        CrewSection(
            crewByDepartment: Dictionary(grouping: CrewMember.mocks, by: \.department),
            transitionNamespace: nil,
            didSelectPerson: { _, _ in }
        )
    }
}
