//
//  CrewMemberRow.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
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

                Text(verbatim: jobsText)
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

    private var jobsText: String {
        member.jobs.map(\.job).joined(separator: ", ")
    }

    private var episodeCountText: String {
        let count = member.totalEpisodeCount
        return "\(count) Episode\(count == 1 ? "" : "s")"
    }

}

#Preview {
    List {
        ForEach(CrewMember.mocks) { member in
            CrewMemberRow(member: member, transitionNamespace: nil)
        }
    }
}
