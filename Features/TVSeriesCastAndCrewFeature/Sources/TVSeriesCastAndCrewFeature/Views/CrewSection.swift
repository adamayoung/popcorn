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

    private var sortedDepartments: [String] {
        let priority = ["Directing", "Writing", "Production", "Camera", "Editing", "Sound", "Art"]
        return crewByDepartment.keys.sorted { lhs, rhs in
            let lhsIndex = priority.firstIndex(of: lhs) ?? Int.max
            let rhsIndex = priority.firstIndex(of: rhs) ?? Int.max
            if lhsIndex != rhsIndex {
                return lhsIndex < rhsIndex
            }
            return lhs < rhs
        }
    }

    var body: some View {
        ForEach(sortedDepartments, id: \.self) { department in
            Section {
                if let members = crewByDepartment[department] {
                    ForEach(members) { member in
                        Button {
                            didSelectPerson(member.id, String(member.id))
                        } label: {
                            CrewMemberRow(member: member, transitionNamespace: transitionNamespace)
                        }
                        .buttonStyle(.plain)
                    }
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
