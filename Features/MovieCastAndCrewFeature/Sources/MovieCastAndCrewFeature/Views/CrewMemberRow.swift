//
//  CrewMemberRow.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct CrewMemberRow: View {

    let member: CrewMember
    let transitionNamespace: Namespace.ID?

    var body: some View {
        HStack(spacing: 12) {
            profileImage

            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: member.personName)
                    .font(.body)

                Text(verbatim: member.job)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var profileImage: some View {
        let image = ProfileImage(url: member.profileURL)
            .frame(width: 50, height: 50)
            .clipShape(Circle())

        if let namespace = transitionNamespace {
            image.matchedTransitionSource(id: member.id, in: namespace)
        } else {
            image
        }
    }

}

#Preview {
    List {
        ForEach(CrewMember.mocks) { member in
            CrewMemberRow(member: member, transitionNamespace: nil)
        }
    }
}
