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

                Text(verbatim: episodeCountText)
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
        let image = ProfileImage(url: member.profileURL)
            .frame(width: 50, height: 50)
            .clipShape(Circle())

        if let namespace = transitionNamespace {
            image.matchedTransitionSource(id: member.id, in: namespace)
        } else {
            image
        }
    }

    private var rolesText: String {
        member.roles.map(\.character).joined(separator: " / ")
    }

    private var episodeCountText: String {
        let count = member.totalEpisodeCount
        return "\(count) Episode\(count == 1 ? "" : "s")"
    }

}

#Preview {
    List {
        ForEach(CastMember.mocks) { member in
            CastMemberRow(member: member, transitionNamespace: nil)
        }
    }
}
