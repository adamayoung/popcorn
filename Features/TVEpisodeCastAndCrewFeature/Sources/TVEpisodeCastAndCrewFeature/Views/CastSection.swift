//
//  CastSection.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct CastSection: View {

    let castMembers: [CastMember]
    let transitionNamespace: Namespace.ID?
    let didSelectPerson: (Int, String?) -> Void

    var body: some View {
        Section {
            ForEach(castMembers) { member in
                Button {
                    didSelectPerson(member.personID, String(member.personID))
                } label: {
                    CastMemberRow(member: member, transitionNamespace: transitionNamespace)
                }
                .buttonStyle(.plain)
            }
        } header: {
            Text("CAST", bundle: .module)
        }
    }

}

#Preview {
    List {
        CastSection(
            castMembers: CastMember.mocks,
            transitionNamespace: nil,
            didSelectPerson: { _, _ in }
        )
    }
}
