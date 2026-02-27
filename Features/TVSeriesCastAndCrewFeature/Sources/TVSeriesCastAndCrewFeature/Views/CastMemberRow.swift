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

                Text(verbatim: rolesText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("EPISODE_COUNT \(member.totalEpisodeCount)", bundle: .module)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var profileImage: some View {
        let image = ProfileImage(url: member.profileURL, initials: member.initials)
            .frame(width: 50, height: 50)
            .clipShape(.circle)

        if let namespace = transitionNamespace {
            image.matchedTransitionSource(id: member.id, in: namespace)
        } else {
            image
        }
    }

    private var rolesText: String {
        member.roles.map(\.character).joined(separator: " / ")
    }

}

#Preview {
    List {
        ForEach(CastMember.mocks) { member in
            CastMemberRow(member: member, transitionNamespace: nil)
        }
    }
}
