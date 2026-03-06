//
//  TVEpisodeDetailsContentView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct TVEpisodeDetailsContentView: View {

    var episode: TVEpisode
    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var didSelectCastAndCrew: () -> Void
    var didSelectPerson: (_ personID: Int) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacing16) {
                StillImage(url: episode.stillURL)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: .spacing12) {
                    if let airDate = episode.airDate {
                        AirDateText(date: airDate)
                            .textCase(.uppercase)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("tv-episode-details.air-date")
                    }

                    if let overview = episode.overview, !overview.isEmpty {
                        Text(verbatim: overview)
                            .font(.body)
                            .accessibilityIdentifier("tv-episode-details.overview")
                    }
                }
                .padding(.horizontal)

                if !castMembers.isEmpty || !crewMembers.isEmpty {
                    castAndCrewCarousel
                        .padding(.bottom)
                }
            }
        }
        .navigationTitle(Text(verbatim: episode.name))
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .accessibilityIdentifier("tv-episode-details.view")
    }

    private var castAndCrewCarousel: some View {
        VStack(alignment: .leading, spacing: .spacing8) {
            sectionHeader("CAST_AND_CREW", action: didSelectCastAndCrew)

            CastAndCrewCarousel(
                castMembers: castMembers,
                crewMembers: crewMembers,
                didSelectPerson: didSelectPerson
            )
        }
    }

    private func sectionHeader(
        _ key: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: .spacing4) {
                Text(key, bundle: .module)
                    .font(.title2)
                    .fontWeight(.bold)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

}

#Preview {
    NavigationStack {
        TVEpisodeDetailsContentView(
            episode: TVEpisode.mock,
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks,
            didSelectCastAndCrew: {},
            didSelectPerson: { _ in }
        )
    }
}
