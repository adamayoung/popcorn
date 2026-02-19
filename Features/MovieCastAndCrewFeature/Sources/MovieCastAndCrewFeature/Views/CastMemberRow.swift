//
//  CastMemberRow.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct CastMemberRow: View {

    let member: CastMember
    let transitionNamespace: Namespace.ID?

    var body: some View {
        HStack(spacing: 12) {
            profileImage

            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: member.personName)
                    .font(.headline)

                Text(verbatim: member.characterName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .accessibilityElement(children: .combine)
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
        ForEach(CastMember.mocks) { member in
            CastMemberRow(member: member, transitionNamespace: nil)
        }
    }
}
