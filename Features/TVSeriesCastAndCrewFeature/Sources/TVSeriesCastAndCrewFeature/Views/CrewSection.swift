//
//  CrewSection.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct CrewSection: View {

    let crewByDepartment: [CrewDepartment]
    let transitionNamespace: Namespace.ID?
    let didSelectPerson: (Int, String?) -> Void

    var body: some View {
        ForEach(crewByDepartment, id: \.department) { group in
            Section {
                ForEach(group.members) { member in
                    Button {
                        didSelectPerson(member.id, String(member.id))
                    } label: {
                        CrewMemberRow(member: member, transitionNamespace: transitionNamespace)
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint(Text("VIEW_PERSON_DETAILS_HINT", bundle: .module))
                }
            } header: {
                Text(verbatim: group.department)
            }
        }
    }

}

#Preview {
    List {
        CrewSection(
            crewByDepartment: CrewDepartment.mocks,
            transitionNamespace: nil,
            didSelectPerson: { _, _ in }
        )
    }
}
